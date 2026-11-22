#!/usr/bin/env python3
"""Synchronise the Nintendo Switch overlay with its upstream sources.

This is a declarative/offline synchroniser. It does not need a working
Portage installed distfile tree: Manifests are rebuilt
from the upstream DIST entries (the overlay uses thin-manifests = true).
Copied patches/source/*.patch files are wired into PATCHES automatically, so
PATCHES-only ebuild patch files are unnecessary.

Commands
    classify   list sync-relevant, version-pinned and Switch-specific packages
    sources    show the state of the upstream checkout/repositories (read-only)
    plan       build a staged copy and show what would change (never writes)
    sync       build, verify, back up and apply the changes
    verify     rebuild the expected tree in a temp dir and compare with target

Safety: sources are only read; the target is only touched by `sync`, after all
patches have applied successfully, and a full backup is written first.  Use
--target to work on a copy while testing.
"""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

try:
    import tomllib
except ImportError:  # pragma: no cover - only on Python < 3.11
    sys.exit("sync_overlay.py needs Python 3.11 or newer (tomllib)")


class SyncError(RuntimeError):
    """A fatal, user-facing error."""


COPY_EXCLUDE_NAMES = {".git", ".gitignore", "__pycache__", "Manifest"}
SNAPSHOT_EXCLUDE_NAMES = {".git", ".gitignore", "__pycache__"}
KEYWORDS_RE = re.compile(r"^(\s*)(#\s*)?KEYWORDS=([\"'])(.*?)\3(\s*(?:#.*)?)$")
ATOM_RE = re.compile(r"^[<>=!~]+")
PATCHES_START_RE = re.compile(r"^(?P<indent>[ \t]*)PATCHES(?P<plus>\+?)=\((?P<rest>.*)$")
FUNCTION_START_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_-]*\(\)[ \t]*\{")


# ---------------------------------------------------------------------------
# configuration
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class EclassRule:
    source: str
    file: str
    patch: str | None


@dataclass(frozen=True)
class SyncSet:
    name: str
    source: str
    packages: tuple[str, ...]
    include_globs: tuple[str, ...]
    keyword_policy: str
    unmask: bool
    auto_stabilize: bool | None = None


@dataclass(frozen=True)
class PackageOptions:
    package: str
    max_version: str | None = None
    exclude_versions: tuple[str, ...] = ()
    keyword_override: str | None = None
    preserve_local_files: tuple[str, ...] = ()
    switch_specific: bool = False
    auto_stabilize: bool | None = None


@dataclass
class Config:
    path: Path
    target: Path
    patches: Path
    unmask: Path
    mask: Path
    sources: dict[str, Path]
    source_auto_stabilize: dict[str, bool | None]
    eclasses: list[EclassRule]
    sync_sets: list[SyncSet]
    package_options: dict[str, PackageOptions]
    unmask_marker: str
    unmask_suffix: str
    keyword_policy: str


def _resolve(base: Path, value: str) -> Path:
    p = Path(value).expanduser()
    return (p if p.is_absolute() else (base / p)).resolve()


def load_config(path: Path) -> Config:
    path = path.expanduser().resolve()
    if not path.is_file():
        raise SyncError(f"config not found: {path}")
    with path.open("rb") as fh:
        data = tomllib.load(fh)

    if data.get("version") != 1:
        raise SyncError(f"unsupported config version: {data.get('version')!r}")

    base = path.parent
    paths = data["paths"]
    settings = data.get("settings", {})
    sources: dict[str, Path] = {}
    source_auto_stabilize: dict[str, bool | None] = {}
    for name, entry in data.get("sources", {}).items():
        if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", name):
            raise SyncError(f"unsafe source name: {name!r}")
        sources[name] = _resolve(base, entry.get("path", f"/var/db/repos/{name}"))
        value = entry.get("auto_stabilize")
        if value is not None and not isinstance(value, bool):
            raise SyncError(f"source '{name}': auto_stabilize must be a boolean")
        source_auto_stabilize[name] = value

    def ensure_source(name: str) -> None:
        """An undeclared source means /var/db/repos/<name> with all defaults."""
        if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", name):
            raise SyncError(f"unsafe source name: {name!r}")
        if name not in sources:
            sources[name] = _resolve(base, f"/var/db/repos/{name}")
            source_auto_stabilize[name] = None

    eclasses = [
        EclassRule(e["source"], e["file"], e.get("patch"))
        for e in data.get("eclasses", [])
    ]
    sync_sets = [
        SyncSet(
            name=s["name"],
            source=s["source"],
            packages=tuple(s.get("packages", [])),
            include_globs=tuple(s.get("include_globs", [])),
            keyword_policy=s.get("keyword_policy", settings.get("keyword_policy", "arm64")),
            unmask=bool(s.get("unmask", False)),
            auto_stabilize=s.get("auto_stabilize"),
        )
        for s in data.get("sync_sets", [])
    ]
    for rule in eclasses + list(sync_sets):
        ensure_source(rule.source)
    # A missing directory is not a config error here: the corresponding
    # sync sets and eclass rules are skipped at runtime (with a message).

    package_options: dict[str, PackageOptions] = {}
    for opt in data.get("package_options", []):
        if opt["package"] in package_options:
            raise SyncError(f"duplicate package_options for {opt['package']}")
        package_options[opt["package"]] = PackageOptions(
            package=opt["package"],
            max_version=opt.get("max_version"),
            exclude_versions=tuple(opt.get("exclude_versions", [])),
            keyword_override=opt.get("keyword_override"),
            preserve_local_files=tuple(opt.get("preserve_local_files", [])),
            switch_specific=bool(opt.get("switch_specific", False)),
            auto_stabilize=opt.get("auto_stabilize"),
        )

    patches = _resolve(base, paths["patches"])
    if not patches.is_dir():
        raise SyncError(f"patches directory not found: {patches}")

    return Config(
        path=path,
        target=_resolve(base, paths["target"]),
        patches=patches,
        unmask=Path(paths["unmask"]),
        mask=Path(paths["mask"]),
        sources=sources,
        source_auto_stabilize=source_auto_stabilize,
        eclasses=eclasses,
        sync_sets=sync_sets,
        package_options=package_options,
        unmask_marker=settings.get("unmask_marker", "# Portage sync"),
        unmask_suffix=settings.get("unmask_repo_suffix", "::switch"),
        keyword_policy=settings.get("keyword_policy", "arm64"),
    )


def check_target(cfg: Config) -> None:
    if not cfg.target.is_dir():
        raise SyncError(f"target overlay not found: {cfg.target}")
    for src in cfg.sources.values():
        if src.resolve() == cfg.target.resolve():
            raise SyncError(f"target and source are the same directory: {src}")
    for rel in (cfg.unmask, cfg.mask):
        if rel.is_absolute():
            raise SyncError(f"profile file must be relative to the target: {rel}")
        if not (cfg.target / rel).is_file():
            raise SyncError(f"missing profile file in target: {rel}")


def missing_sources(cfg: Config) -> list[tuple[str, Path]]:
    """Configured overlay sources whose directory is currently absent."""
    return [(name, root) for name, root in cfg.sources.items() if not root.is_dir()]


def report_missing_sources(cfg: Config) -> set[str]:
    """Tell the user which overlays are skipped, and return their names."""
    missing = missing_sources(cfg)
    for name, root in missing:
        print(f"Skip sync for {name} packages, {root} missing")
    return {name for name, _ in missing}


# ---------------------------------------------------------------------------
# version / ebuild helpers
# ---------------------------------------------------------------------------


def version_key(version: str) -> tuple:
    """Comparable key for package versions (1.2-r3, 9999, 2.4_pre2024...)."""
    m = re.match(r"^(.*?)(?:-r(\d+))?$", version.strip())
    core, revision = m.group(1), int(m.group(2) or 0)
    parts: list[tuple[int, object]] = []
    for token in re.split(r"[._-]+", core):
        if not token:
            continue
        parts.append((0, int(token)) if token.isdigit() else (1, token))
    return (tuple(parts), revision)


def ebuild_version(filename: str, pn: str) -> str | None:
    prefix = pn + "-"
    if filename.startswith(prefix) and filename.endswith(".ebuild"):
        return filename[len(prefix) : -len(".ebuild")]
    return None


def package_versions(directory: Path) -> list[str]:
    if not directory.is_dir():
        return []
    pn = directory.name
    return sorted(
        v for f in directory.glob("*.ebuild") if (v := ebuild_version(f.name, pn))
    )


def list_packages(root: Path) -> dict[str, Path]:
    """All category/package dirs below root that contain at least one ebuild."""
    result: dict[str, Path] = {}
    if not root.is_dir():
        return result
    for category in root.iterdir():
        if not category.is_dir() or not re.fullmatch(r"[a-z][a-z0-9-]*", category.name):
            continue
        for package in category.iterdir():
            if package.is_dir() and any(package.glob("*.ebuild")):
                result[f"{category.name}/{package.name}"] = package
    return result


# ---------------------------------------------------------------------------
# transformations
# ---------------------------------------------------------------------------


def rewrite_keywords(text: str, policy: str) -> tuple[str, bool]:
    """Map upstream KEYWORDS to the single Switch architecture.

    A stable keyword (or * / **) becomes arm64, a testing-only keyword list
    becomes ~arm64.  Indentation and a leading '#' are preserved; the old
    shell script silently destroyed both.
    """
    if policy == "keep":
        return text, False
    if policy != "arm64":
        raise SyncError(f"unknown keyword policy: {policy!r}")

    lines = text.splitlines(keepends=True)
    changed = False
    for i, line in enumerate(lines):
        eol = "\n" if line.endswith("\n") else ""
        m = KEYWORDS_RE.match(line[: -len(eol)] if eol else line)
        if not m:
            continue
        words = m.group(4).split()
        stable = any(w == "*" or (w and not w.startswith(("~", "-"))) for w in words)
        new_value = "arm64" if stable else "~arm64"
        quote = m.group(3)
        new_line = f"{m.group(1)}{m.group(2) or ''}KEYWORDS={quote}{new_value}{quote}{m.group(5)}{eol}"
        if new_line != line:
            lines[i] = new_line
            changed = True
    return "".join(lines), changed


def stabilize_keywords(text: str) -> tuple[str, bool]:
    """Turn a testing-only ~arm64 ebuild into a stable arm64 ebuild."""
    lines = text.splitlines(keepends=True)
    changed = False
    for i, line in enumerate(lines):
        eol = "\n" if line.endswith("\n") else ""
        m = KEYWORDS_RE.match(line[: -len(eol)] if eol else line)
        if not m or m.group(4).split() != ["~arm64"]:
            continue
        quote = m.group(3)
        new_line = f"{m.group(1)}{m.group(2) or ''}KEYWORDS={quote}arm64{quote}{m.group(5)}{eol}"
        if new_line != line:
            lines[i] = new_line
            changed = True
    return "".join(lines), changed


def effective_auto_stabilize(cfg: Config, cp: str, rules: SyncSet) -> bool:
    """Resolve package -> sync set -> source -> default."""
    options = cfg.package_options.get(cp)
    candidates = (
        options.auto_stabilize if options else None,
        rules.auto_stabilize,
        cfg.source_auto_stabilize.get(rules.source),
    )
    for value in candidates:
        if value is not None:
            return value
    return False


def apply_keyword_override(text: str, keywords: str) -> tuple[str, bool]:
    """Replace an already normalised KEYWORDS line with an explicit value."""
    lines = text.splitlines(keepends=True)
    changed = False
    for i, line in enumerate(lines):
        eol = "\n" if line.endswith("\n") else ""
        m = KEYWORDS_RE.match(line[: -len(eol)] if eol else line)
        if not m:
            continue
        quote = m.group(3)
        new_line = (
            f"{m.group(1)}{m.group(2) or ''}KEYWORDS="
            f"{quote}{keywords}{quote}{m.group(5)}{eol}"
        )
        if new_line != line:
            lines[i] = new_line
            changed = True
    return "".join(lines), changed


def inject_patch_references(text: str, patch_names: Iterable[str]) -> tuple[str, bool]:
    """Wire copied files/*.patch into PATCHES, without duplicating entries.

    If the file is referenced anywhere already (PATCHES, PATCHES+= or eapply),
    nothing is changed. This makes the transformation safe to run after the
    existing ebuild patches and makes PATCHES-only patch files unnecessary.
    """
    names = [name for name in dict.fromkeys(patch_names) if name.endswith(".patch")]
    missing = [name for name in names if name not in text]
    if not missing:
        return text, False

    lines = text.splitlines(keepends=True)
    entries_for = lambda indent: [
        f'{indent}\t"${{FILESDIR}}"/{name}' for name in missing
    ]

    for i, line in enumerate(lines):
        raw = line.rstrip("\r\n")
        m = PATCHES_START_RE.match(raw)
        if not m:
            continue
        indent, plus, rest = m.group("indent"), m.group("plus"), m.group("rest")
        entries = entries_for(indent)

        if rest.rstrip().endswith(")"):
            body = rest.rstrip()[:-1].strip()
            replacement = [f"{indent}PATCHES{plus}=(\n"]
            if body:
                replacement.append(f"{indent}\t{body}\n")
            replacement.extend(f"{entry}\n" for entry in entries)
            replacement.append(f"{indent})\n")
            lines[i : i + 1] = replacement
            return "".join(lines), True

        close_re = re.compile(re.escape(indent) + r"\)[ \t]*(?:#.*)?$")
        for j in range(i + 1, len(lines)):
            if close_re.match(lines[j].rstrip("\r\n")):
                lines[j:j] = [f"{entry}\n" for entry in entries]
                return "".join(lines), True
        raise SyncError("found an unterminated PATCHES=( block in ebuild")

    # No array yet: place it after IUSE/SLOT when available, otherwise just
    # before the first function definition.
    anchor = next(
        (
            i
            for i, line in enumerate(lines)
            if re.match(r"^IUSE=", line.rstrip("\r\n"))
        ),
        None,
    )
    if anchor is None:
        anchor = next(
            (
                i
                for i, line in enumerate(lines)
                if re.match(r"^SLOT=", line.rstrip("\r\n"))
            ),
            None,
        )
    before_function = anchor is None
    if before_function:
        insert_at = next(
            (
                i
                for i, line in enumerate(lines)
                if FUNCTION_START_RE.match(line.rstrip("\r\n"))
            ),
            len(lines),
        )
    else:
        insert_at = anchor + 1

    if len(missing) == 1:
        block = [f'PATCHES=( "${{FILESDIR}}"/{missing[0]} )\n']
    else:
        block = ["PATCHES=(\n"] + [f"{entry}\n" for entry in entries_for("")] + [")\n"]
    if insert_at > 0 and lines[insert_at - 1].strip():
        block.insert(0, "\n")
    if before_function and insert_at < len(lines) and lines[insert_at].strip():
        block.append("\n")
    lines[insert_at:insert_at] = block
    return "".join(lines), True


def select_ebuild_patch(patch_dir: Path, pn: str, pvr: str) -> Path | None:
    """Exact patch, else newest patch whose version is <= the ebuild version."""
    exact = patch_dir / f"{pn}-{pvr}.patch"
    if exact.is_file():
        return exact

    candidates: list[tuple[tuple, str, Path]] = []
    for patch in patch_dir.glob(f"{pn}-*.patch"):
        version = patch.name[len(pn) + 1 : -len(".patch")]
        key = version_key(version)
        if key <= version_key(pvr):
            candidates.append((key, version, patch))
    if candidates:
        return max(candidates, key=lambda x: x[0])[2]

    generic = patch_dir / f"{pn}.patch"
    return generic if generic.is_file() else None


def run_patch(patch: Path, target: Path) -> None:
    """Apply one unified diff to a single file, in a staging directory only."""
    cmd = [
        "patch",
        "-p1",
        "--batch",
        "--forward",
        "--no-backup-if-mismatch",
        "-i",
        str(patch),
        str(target),
    ]
    result = subprocess.run(cmd, text=True, capture_output=True)
    if result.returncode != 0:
        raise SyncError(
            f"patch failed: {patch.name} -> {target.name}\n"
            f"{result.stdout.strip()}\n{result.stderr.strip()}"
        )


def manifest_dist_lines(src: Path) -> str:
    if not src.is_file():
        return ""
    return "".join(
        line for line in src.read_text(errors="replace").splitlines(keepends=True)
        if line.startswith("DIST ")
    )


def copy_package_source(src: Path, dst: Path) -> None:
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(
        src,
        dst,
        ignore=shutil.ignore_patterns(*COPY_EXCLUDE_NAMES),
        symlinks=False,
    )


def version_allowed(options: PackageOptions, version: str) -> bool:
    """All upstream versions are synced unless explicitly excluded or too new.

    Versions above ``max_version`` stay in the overlay at their current version
    and therefore become version-pinned until the limit is raised.
    """
    if version in options.exclude_versions:
        return False
    if options.max_version and version_key(version) > version_key(options.max_version):
        return False
    return True


def sync_package(
    cfg: Config,
    cp: str,
    src: Path,
    stage: Path,
    rules: SyncSet,
) -> tuple[list[str], bool]:
    """Copy one package into the staged overlay and apply all local changes."""
    pn = cp.split("/", 1)[1]
    options = cfg.package_options.get(cp, PackageOptions(cp))
    dst = stage / cp
    up_manifest = manifest_dist_lines(src / "Manifest")
    copy_package_source(src, dst)

    # Drop upstream versions that this overlay intentionally does not carry.
    for ebuild in dst.glob("*.ebuild"):
        pvr = ebuild_version(ebuild.name, pn)
        if pvr and not version_allowed(options, pvr):
            ebuild.unlink()
    for subdir in (dst / "files").glob("*"):
        if subdir.is_dir() and re.match(r"^\d", subdir.name):
            if not version_allowed(options, subdir.name):
                shutil.rmtree(subdir)

    # Files that are hand-maintained in the overlay win over the source copy.
    for rel in options.preserve_local_files:
        rel_path = Path(rel)
        if rel_path.is_absolute() or ".." in rel_path.parts:
            raise SyncError(f"unsafe preserve_local_files entry: {rel}")
        local = cfg.target / cp / rel_path
        if local.is_file():
            target = dst / rel_path
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(local, target)

    patch_files: list[str] = []
    patch_src = cfg.patches / "source" / pn
    if patch_src.is_dir():
        files_dir = dst / "files"
        files_dir.mkdir(exist_ok=True)
        for f in sorted(patch_src.iterdir()):
            if f.is_file():
                shutil.copy2(f, files_dir / f.name)
                if f.suffix == ".patch":
                    patch_files.append(f.name)

    # Never lose hand-added FILESDIR entries missing from upstream/source.
    local_files_dir = cfg.target / cp / "files"
    if local_files_dir.is_dir():
        for local in sorted(local_files_dir.rglob("*")):
            if not local.is_file():
                continue
            rel = local.relative_to(cfg.target / cp)
            if not (dst / rel).exists():
                staged = dst / rel
                staged.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(local, staged)

    applied: list[str] = []
    keyword_changes = 0
    auto_stabilize = effective_auto_stabilize(cfg, cp, rules)
    for ebuild in sorted(dst.glob("*.ebuild")):
        pvr = ebuild_version(ebuild.name, pn)
        if pvr is None:
            raise SyncError(f"unexpected ebuild name: {ebuild}")
        text = ebuild.read_text(errors="replace")
        text, kw_changed = rewrite_keywords(text, rules.keyword_policy)
        if auto_stabilize and "9999" not in pvr:
            text, stabilized = stabilize_keywords(text)
            kw_changed = kw_changed or stabilized
        if options.keyword_override:
            text, override_changed = apply_keyword_override(text, options.keyword_override)
            kw_changed = kw_changed or override_changed
        if kw_changed:
            ebuild.write_text(text)
            keyword_changes += 1

        patch = select_ebuild_patch(cfg.patches / "ebuild", pn, pvr)
        if patch:
            run_patch(patch, ebuild)
            applied.append(f"{cp}/{ebuild.name}: {patch.name}")

        if patch_files:
            text = ebuild.read_text(errors="replace")
            text, patched = inject_patch_references(text, patch_files)
            if patched:
                ebuild.write_text(text)
                applied.append(f"{cp}/{ebuild.name}: PATCHES <- files/")

    if keyword_changes:
        policy = options.keyword_override or rules.keyword_policy
        if auto_stabilize:
            policy += " + auto-stabilize (releases only)"
        applied.insert(0, f"{cp}: KEYWORDS -> {policy} ({keyword_changes} ebuilds)")

    # thin-manifests = true: only DIST entries are required, so this works
    # completely offline and without calling `ebuild ... manifest`.
    manifest = dst / "Manifest"
    if up_manifest:
        manifest.write_text(up_manifest)
    else:
        manifest.unlink(missing_ok=True)

    has_live = any(
        (v or "").startswith("9999")
        for f in dst.glob("*.ebuild")
        if (v := ebuild_version(f.name, pn))
    )
    return applied, has_live


def sync_eclass(cfg: Config, rule: EclassRule, stage: Path) -> str:
    src = cfg.sources[rule.source] / "eclass" / rule.file
    if not src.is_file():
        raise SyncError(f"eclass not found: {src}")
    dst = stage / "eclass" / rule.file
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    if rule.patch:
        run_patch(cfg.patches / rule.patch, dst)
    return f"eclass/{rule.file} <- {rule.source}"


def generate_unmask(cfg: Config, stage: Path, cp_list: Iterable[str]) -> str:
    path = stage / cfg.unmask
    text = path.read_text(errors="replace")
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    found = False
    for line in lines:
        if cfg.unmask_marker in line:
            found = True
            out.append(
                "# Portage sync - generated by sync/sync_overlay.py; "
                "add manual entries above this line\n"
            )
            for cp in sorted(set(cp_list)):
                for version in package_versions(stage / cp):
                    out.append(f"={cp}-{version}{cfg.unmask_suffix}\n")
            # Everything below the marker belongs to the generated block.
            break
        out.append(line)
    if not found:
        raise SyncError(f"unmask marker {cfg.unmask_marker!r} not found in {path}")
    new_text = "".join(out)
    path.write_text(new_text)
    return new_text


# ---------------------------------------------------------------------------
# staging, diffing, applying
# ---------------------------------------------------------------------------


@dataclass
class SyncPlan:
    workdir: Path
    stage: Path
    changes: dict[str, list[str]]
    transformations: list[str]
    notes: list[str]
    synced_packages: list[str]

    @property
    def total_changes(self) -> int:
        return sum(len(v) for v in self.changes.values())


def expected_package_sets(cfg: Config) -> dict[str, SyncSet]:
    """Map CP -> rule for all packages that this config manages."""
    result: dict[str, SyncSet] = {}
    for rules in cfg.sync_sets:
        for cp in rules.packages:
            if cp in result:
                raise SyncError(f"package {cp} configured twice")
            result[cp] = rules
    return result


def resolve_set_packages(
    cfg: Config,
    rules: SyncSet,
    target_packages: dict[str, Path],
    allow_missing: bool = False,
) -> list[str]:
    result = set(rules.packages)
    for cp, path in target_packages.items():
        if any(fnmatch.fnmatch(cp, pattern) for pattern in rules.include_globs):
            result.add(cp)
    selected: list[str] = []
    for cp in sorted(result):
        if not allow_missing and not (cfg.sources[rules.source] / cp).is_dir():
            if cp in rules.packages:
                raise SyncError(f"{rules.name}: source package missing: {cp}")
            continue  # Switch-only package in a globbed category
        if cp not in target_packages:
            continue  # upstream package not present in the overlay -> no new packages
        selected.append(cp)
    return selected


def file_snapshot(root: Path) -> dict[str, tuple[int, str]]:
    result: dict[str, tuple[int, str]] = {}
    if not root.exists():
        return result
    for p in root.rglob("*"):
        if not p.is_file() or any(
            part in SNAPSHOT_EXCLUDE_NAMES for part in p.relative_to(root).parts
        ):
            continue
        digest = hashlib.sha256(p.read_bytes()).hexdigest()
        result[p.relative_to(root).as_posix()] = (p.stat().st_mode & 0o777, digest)
    return result


def compute_changes(cfg: Config, stage: Path, synced: list[str]) -> dict[str, list[str]]:
    allowed: set[str] = set()
    for cp in synced:
        allowed.add(cp)
    for rule in cfg.eclasses:
        allowed.add(f"eclass/{rule.file}")
    allowed.add(cfg.unmask.as_posix())

    before = file_snapshot(cfg.target)
    after = file_snapshot(stage)
    changes: dict[str, list[str]] = {"added": [], "modified": [], "removed": []}
    for rel in sorted(set(before) | set(after)):
        if not any(rel == root or rel.startswith(root + "/") for root in allowed):
            continue
        if rel not in before:
            changes["added"].append(rel)
        elif rel not in after:
            changes["removed"].append(rel)
        elif before[rel] != after[rel]:
            changes["modified"].append(rel)
    return changes


def build_plan(cfg: Config, workdir: Path) -> SyncPlan:
    check_target(cfg)
    expected_package_sets(cfg)  # validate explicit package entries
    stage = workdir / "overlay"
    shutil.copytree(
        cfg.target,
        stage,
        ignore=shutil.ignore_patterns(*COPY_EXCLUDE_NAMES),
        symlinks=False,
    )
    transformations: list[str] = []
    notes: list[str] = []
    synced: list[str] = []
    rules_by_cp: dict[str, SyncSet] = {}
    skipped = {name for name, _ in missing_sources(cfg)}
    if skipped:
        notes.append("skipped sources: " + ", ".join(sorted(skipped)))

    for rule in cfg.eclasses:
        if rule.source in skipped:
            continue
        transformations.append(sync_eclass(cfg, rule, stage))

    target_packages = list_packages(cfg.target)
    live_count = 0
    for rules in cfg.sync_sets:
        if rules.source in skipped:
            continue
        for cp in resolve_set_packages(cfg, rules, target_packages):
            src = cfg.sources[rules.source] / cp
            changes, has_live = sync_package(cfg, cp, src, stage, rules)
            transformations.extend(changes)
            live_count += int(has_live)
            synced.append(cp)
            rules_by_cp[cp] = rules
    if live_count:
        notes.append(
            f"{live_count} packages contain live (9999) ebuilds; "
            "use smart-live-rebuild separately if needed"
        )

    unmask_cps = [cp for cp in synced if rules_by_cp[cp].unmask]
    if unmask_cps:
        transformations.append(f"{cfg.unmask}: regenerated")
        generate_unmask(cfg, stage, unmask_cps)

    # Sanity checks on the staged tree before anything is applied.
    for cp in synced:
        for ebuild in (stage / cp).glob("*.ebuild"):
            keywords = [l.strip() for l in ebuild.read_text(errors="replace").splitlines()
                        if "KEYWORDS=" in l]
            override = cfg.package_options.get(cp, PackageOptions(cp)).keyword_override
            allowed_keywords = set((override or "arm64 ~arm64").split())
            bad: list[str] = []
            for line in keywords:
                m = KEYWORDS_RE.match(line.strip())
                if not m or not set(m.group(4).split()).issubset(allowed_keywords):
                    bad.append(line)
            if bad:
                raise SyncError(f"keyword rewrite failed for {cp}/{ebuild.name}: {bad}")

    return SyncPlan(
        workdir=workdir,
        stage=stage,
        changes=compute_changes(cfg, stage, synced),
        transformations=transformations,
        notes=notes,
        synced_packages=synced,
    )


def print_plan(plan: SyncPlan, target: Path) -> None:
    print(f"target: {target}")
    print(f"synced packages: {len(plan.synced_packages)}")
    for label, key in (
        ("new", "added"),
        ("changed", "modified"),
        ("removed", "removed"),
    ):
        files = plan.changes[key]
        print(f"{label}: {len(files)}")
        for rel in files[:40]:
            print(f"  {key[0].upper()} {rel}")
        if len(files) > 40:
            print(f"  ... and {len(files) - 40} more")
    print(f"transformations: {len(plan.transformations)}")
    for t in plan.transformations[:40]:
        print(f"  - {t}")
    if len(plan.transformations) > 40:
        print(f"  ... and {len(plan.transformations) - 40} more")
    for note in plan.notes:
        print(f"note: {note}")


def backup_target(target: Path) -> Path:
    backup = Path(tempfile.mkdtemp(prefix="switch-overlay-backup-"))
    shutil.copytree(target, backup / "overlay", ignore=shutil.ignore_patterns(".git"))
    return backup


def apply_plan(cfg: Config, plan: SyncPlan, backup: Path) -> None:
    for rel in plan.changes["removed"]:
        p = cfg.target / rel
        if p.is_file():
            p.unlink()
        # remove directories emptied by the removal, but never the overlay root
        current = p.parent
        while current != cfg.target and current.is_dir() and not any(current.iterdir()):
            current.rmdir()
            current = current.parent

    for rel in plan.changes["added"] + plan.changes["modified"]:
        src = plan.stage / rel
        dst = cfg.target / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        fd, tmp_name = tempfile.mkstemp(
            prefix=f".{dst.name}.", suffix=".sync-tmp", dir=dst.parent
        )
        os.close(fd)
        try:
            shutil.copy2(src, tmp_name)
            os.replace(tmp_name, dst)
        finally:
            Path(tmp_name).unlink(missing_ok=True)

    print(f"applied {plan.total_changes} file change(s) to {cfg.target}")
    print(f"backup: {backup}")


# ---------------------------------------------------------------------------
# classification / source reporting
# ---------------------------------------------------------------------------


def masked_package_comments(mask_file: Path, known: Iterable[str]) -> dict[str, str]:
    """Map masked CATEGORY/PN to the comment block that explains the mask."""
    known_sorted = sorted(set(known), key=len, reverse=True)
    found: dict[str, list[str]] = {}
    if not mask_file.is_file():
        return {}
    pending: list[str] = []
    consumed = False
    for raw in mask_file.read_text(errors="replace").splitlines():
        line = raw.strip()
        if not line:
            if consumed:
                pending = []
                consumed = False
            continue
        if line.startswith("#"):
            if consumed:
                pending = []
                consumed = False
            pending.append(line.lstrip("#").strip())
            continue
        atom_part, sep, inline = line.partition("#")
        atom = ATOM_RE.sub("", atom_part.strip())
        if sep and inline.strip():
            pending.append(inline.strip())
        for cp in known_sorted:
            if atom == cp or atom.startswith(cp + "-"):
                comment = " ".join(part for part in pending if part)
                if comment and comment not in found.setdefault(cp, []):
                    found[cp].append(comment)
                break
        consumed = True
    return {cp: " | ".join(parts) for cp, parts in found.items()}


def local_overlay_packages(exclude_roots: Iterable[Path]) -> dict[str, list[str]]:
    """Find packages in other repos under /var/db/repos (read-only)."""
    root = Path("/var/db/repos")
    result: dict[str, list[str]] = {}
    if not root.is_dir():
        return result
    excluded = {p.resolve() for p in exclude_roots}
    for repo in sorted(root.iterdir(), key=lambda p: p.name):
        if not repo.is_dir() or repo.name.startswith(".") or repo.resolve() in excluded:
            continue
        for category in sorted(repo.iterdir(), key=lambda p: p.name):
            if not category.is_dir() or category.name.startswith("."):
                continue
            for package in category.iterdir():
                if package.is_dir() and not package.name.startswith("."):
                    cp = f"{category.name}/{package.name}"
                    result.setdefault(cp, []).append(repo.name)
    return result


def upstream_copies(
    cp: str,
    sources: dict[str, Path],
    local_packages: dict[str, list[str]],
) -> list[tuple[str, list[str]]]:
    """Every repository outside the target that carries this package."""
    copies: list[tuple[str, list[str]]] = []
    for name, root in sources.items():
        versions = package_versions(root / cp)
        if versions:
            copies.append((name, versions))
    for repo in local_packages.get(cp, []):
        versions = package_versions(Path("/var/db/repos") / repo / cp)
        if versions:
            copies.append((repo, versions))
    return copies


def newer_copies(
    own: list[str],
    copies: list[tuple[str, list[str]]],
) -> list[tuple[str, list[str]]]:
    """Copies that contain at least one version newer than the local one."""
    own_best = max((version_key(v) for v in own), default=None)
    if own_best is None:
        return copies
    return [
        (name, versions)
        for name, versions in copies
        if any(version_key(v) > own_best for v in versions)
    ]


def classify(cfg: Config) -> dict[str, list[dict[str, str]]]:
    check_target(cfg)
    target_packages = list_packages(cfg.target)
    source_packages = {name: list_packages(root) for name, root in cfg.sources.items()}
    local_packages = local_overlay_packages(cfg.sources.values())
    all_upstream = set().union(
        *(set(p) for p in source_packages.values()), set(local_packages)
    )
    managed: dict[str, SyncSet] = {}
    skipped = {name for name, _ in missing_sources(cfg)}
    for rules in cfg.sync_sets:
        for cp in resolve_set_packages(
            cfg, rules, target_packages, allow_missing=rules.source in skipped
        ):
            managed[cp] = rules

    known = set(target_packages) | all_upstream
    masked = masked_package_comments(cfg.target / cfg.mask, known)
    switch_specific = {
        cp for cp, opt in cfg.package_options.items() if opt.switch_specific
    }
    groups: dict[str, list[dict[str, str]]] = {
        "sync": [], "pinned": [], "unmanaged": [], "switch-unique": []
    }
    for cp in sorted(target_packages):
        if cp in managed:
            rules = managed[cp]
            groups["sync"].append(
                {"package": cp, "reason": f"{rules.name} <- {rules.source}"}
            )
            continue

        if cp in switch_specific:
            groups["switch-unique"].append(
                {
                    "package": cp,
                    "reason": "local fork with hardware-specific patches "
                    "(configured switch-specific)",
                }
            )
            continue

        own_versions = package_versions(target_packages[cp])
        copies = upstream_copies(cp, cfg.sources, local_packages)
        newer = newer_copies(own_versions, copies)

        if cp in masked:
            label = "pinned version" if len(own_versions) == 1 else "pinned versions"
            reasons = [f"{label}: {', '.join(own_versions)}"]
            reasons.append(f"masked in nintendo_switch profile: {masked[cp]}")
            if newer:
                reasons.append("newer upstream version exists")
            groups["pinned"].append({"package": cp, "reason": "; ".join(reasons)})
            continue

        if copies:
            if newer:
                detail = "; ".join(
                    f"newer in {name}: {', '.join(versions)}"
                    for name, versions in newer
                )
                prefix = f"old local version: {', '.join(own_versions)}; {detail}"
            else:
                detail = "; ".join(
                    f"{name}: {', '.join(versions)}" for name, versions in copies
                )
                prefix = f"upstream copy ({detail})"
            groups["unmanaged"].append(
                {
                    "package": cp,
                    "reason": prefix + "; not managed by sync config",
                }
            )
            continue

        groups["switch-unique"].append(
            {
                "package": cp,
                "reason": "not found in configured sources or /var/db/repos overlays",
            }
        )
    return groups


def print_classification(groups: dict[str, list[dict[str, str]]], fmt: str) -> None:
    if fmt == "json":
        print(json.dumps(groups, indent=2, ensure_ascii=False))
        return
    titles = {
        "sync": "SYNC-RELEVANT (copied from upstream, local changes reapplied)",
        "pinned": "VERSION-PINNED (pinned version and mask reason)",
        "unmanaged": "UNMANAGED (old version, no mask, no sync - review)",
        "switch-unique": "SWITCH-SPECIFIC (not found in configured sources or /var/db/repos)",
    }
    for key, title in titles.items():
        entries = groups[key]
        print(f"\n== {title} ({len(entries)}) ==")
        for item in entries:
            print(f"  {item['package']:<52} {item['reason']}")


def report_sources(cfg: Config) -> None:
    for name, root in cfg.sources.items():
        if not root.is_dir():
            print(f"{name:10} {root}")
            print("           MISSING")
            continue
        head = subprocess.run(
            ["git", "-C", str(root), "rev-parse", "--short", "HEAD"],
            text=True, capture_output=True,
        ).stdout.strip() or "no git checkout"
        date = subprocess.run(
            ["git", "-C", str(root), "log", "-1", "--format=%cd", "--date=short"],
            text=True, capture_output=True,
        ).stdout.strip()
        dirty = subprocess.run(
            ["git", "-C", str(root), "status", "--porcelain"],
            text=True, capture_output=True,
        ).stdout.strip()
        print(f"{name:10} {root}")
        print(f"           HEAD {head} ({date})"
              + ("  *** LOCAL CHANGES ***" if dirty else ""))


def check_ebuild_patches(cfg: Config, packages: list[str]) -> int:
    """Test every selected ebuild patch against its upstream ebuild.

    This is generic: it covers every synced package that has an ebuild patch.
    A FAIL means the currently selected patch does not apply and a new
    patch named after that ebuild version is needed.
    """
    check_target(cfg)
    expected = expected_package_sets(cfg)
    target_packages = list_packages(cfg.target)
    skipped = {name for name, _ in missing_sources(cfg)}

    if packages:
        unknown = [cp for cp in packages if cp not in expected]
        if unknown:
            raise SyncError(f"unknown package(s) in config: {', '.join(unknown)}")
        rules_by_cp = {
            cp: expected[cp] for cp in packages if expected[cp].source not in skipped
        }
    else:
        rules_by_cp = {}
        for rules in cfg.sync_sets:
            if rules.source in skipped:
                continue
            for cp in resolve_set_packages(cfg, rules, target_packages):
                rules_by_cp[cp] = rules

    if not rules_by_cp:
        print("No synced packages to check")
        return 0

    failures: list[str] = []
    checked = 0
    with tempfile.TemporaryDirectory(prefix="switch-overlay-patchcheck-") as td:
        tmp = Path(td)
        for cp in sorted(rules_by_cp):
            rules = rules_by_cp[cp]
            pn = cp.split("/", 1)[1]
            options = cfg.package_options.get(cp, PackageOptions(cp))
            auto_stabilize = effective_auto_stabilize(cfg, cp, rules)
            src = cfg.sources[rules.source] / cp
            if not src.is_dir():
                failures.append(f"{cp}: source directory missing: {src}")
                continue
            for ebuild in sorted(src.glob("*.ebuild")):
                pvr = ebuild_version(ebuild.name, pn)
                if pvr is None or not version_allowed(options, pvr):
                    continue
                patch = select_ebuild_patch(cfg.patches / "ebuild", pn, pvr)
                if patch is None:
                    print(f"SKIP {cp}/{ebuild.name}: no ebuild patch")
                    continue
                target = tmp / ebuild.name
                text = ebuild.read_text(errors="replace")
                text, _ = rewrite_keywords(text, rules.keyword_policy)
                if auto_stabilize and "9999" not in pvr:
                    text, _ = stabilize_keywords(text)
                if options.keyword_override:
                    text, _ = apply_keyword_override(text, options.keyword_override)
                target.write_text(text)
                checked += 1
                try:
                    run_patch(patch, target)
                except SyncError as exc:
                    print(f"FAIL {cp}/{ebuild.name}: {patch.name}")
                    failures.append(f"{cp}/{ebuild.name}: {patch.name}\n{exc}")
                else:
                    print(f"OK   {cp}/{ebuild.name}: {patch.name}")

    print(f"checked {checked} ebuild/patch combination(s)")
    if failures:
        print(f"PATCH CHECK FAILED ({len(failures)})")
        for failure in failures:
            print(f"  - {failure}")
        return 1
    print("PATCH CHECK OK")
    return 0


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--config",
        type=Path,
        default=Path(__file__).with_name("sync.toml"),
        help="path to sync.toml (default: next to this script)",
    )
    parser.add_argument(
        "--target", type=Path, help="override the target overlay (use a copy for tests)"
    )
    sub = parser.add_subparsers(dest="command", required=True)

    p_class = sub.add_parser("classify", help="report package groups")
    p_class.add_argument("--format", choices=("text", "json"), default="text")

    sub.add_parser("sources", help="report upstream repository state")

    p_patches = sub.add_parser(
        "check-patches", help="test all ebuild patches against upstream ebuilds"
    )
    p_patches.add_argument(
        "packages", nargs="*", help="limit the check to these CATEGORY/PN entries"
    )

    sub.add_parser("plan", help="show planned changes, write nothing")

    p_sync = sub.add_parser("sync", help="apply the synchronisation")
    p_sync.add_argument("--yes", action="store_true", help="do not ask for confirmation")

    sub.add_parser("verify", help="compare target against freshly staged result")

    args = parser.parse_args()
    try:
        cfg = load_config(args.config)
        if args.target:
            cfg.target = args.target.expanduser().resolve()

        if args.command != "sources":
            report_missing_sources(cfg)

        if args.command == "sources":
            report_sources(cfg)
            return 0

        if args.command == "classify":
            print_classification(classify(cfg), args.format)
            return 0

        if args.command == "check-patches":
            return check_ebuild_patches(cfg, args.packages)

        check_target(cfg)
        work = Path(tempfile.mkdtemp(prefix="switch-overlay-plan-"))
        try:
            plan = build_plan(cfg, work)
            if args.command == "plan":
                print_plan(plan, cfg.target)
                return 0

            if args.command == "verify":
                if plan.total_changes:
                    print_plan(plan, cfg.target)
                    print("VERIFY FAILED: target differs from expected tree")
                    return 1
                print(f"VERIFY OK: {cfg.target} matches the sync result")
                return 0

            # sync
            if os.geteuid() == 0:
                print("WARNING: running as root; double-check --target before continuing")
            print_plan(plan, cfg.target)
            if plan.total_changes == 0:
                print("Nothing to do; target is already in sync")
                return 0
            if not args.yes:
                if not sys.stdin.isatty():
                    raise SyncError("refusing to write without --yes on a non-interactive shell")
                answer = input("Apply these changes? [y/N] ")
                if answer.strip().lower() not in ("y", "yes"):
                    print("Aborted")
                    return 1
            backup = backup_target(cfg.target)
            apply_plan(cfg, plan, backup)
            return 0
        finally:
            shutil.rmtree(work, ignore_errors=True)
    except SyncError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
