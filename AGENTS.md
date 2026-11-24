# Agent notes: overlay repository

## Purpose

This repository is the Gentoo overlay for the Nintendo Switch. It holds profile
settings, locally maintained packages and copies of upstream packages with
local changes. The tool in `sync/` keeps those copies aligned with configured
source repositories.

## Layout

- `profiles/nintendo_switch/` - target profiles, mask and unmask files.
- `sys-apps/nintendo-switch-meta` - meta package selecting optional hardware
  and desktop features.
- `sync/` - declarative offline synchroniser; see `sync/AGENTS.md`.
- `README.md` - user-facing documentation. It contains the table of locally
  maintained packages with descriptions. `sync_overlay.py classify` reads that
  `Package | Description` table, so keep the two in sync.
- `bootstrap.md` - installation guide.

## Package groups (from `classify`)

- SYNC-RELEVANT: covered by a sync set; copied from a source with local changes
  reapplied. These are the only packages the synchroniser writes.
- VERSION-PINNED: active entry in the profile mask file; never overwritten;
  the mask comment is displayed.
- UNMANAGED: older local copy with neither mask nor sync rule while a newer copy
  exists in another installed repository; needs manual review.
- SWITCH-SPECIFIC: exists only here, not in any configured source or in
  `/var/db/repos`; never overwritten. Descriptions come from the main README
  table.

Groups are derived from configuration, masks and repositories. Do not hard-code
package lists in documentation or tooling.

## Rules for changes

- Keep wording generic. Name individual packages only when they are the subject
  of the change or are listed in configuration.
- Preserve existing README content, including maintainer placeholders, unless
  the task explicitly targets it. Prefer focused edits over rewrites.
- Local ebuild changes belong in `sync/patches/`, not in hand-edited copies;
  a later sync must reproduce them.
- A patch must only touch files present in every version it applies to. Reuse a
  patch until it first fails, then add a version-specific one.
- Every upstream ebuild in a configured source is copied. There is no minimum
  version. `max_version` and `exclude_versions` are only for known-bad versions
  and are not added by default.
- Manifests are written from upstream `DIST` lines. Never run
  `ebuild ... manifest`; keep the synchroniser offline.

## Upstream sources for core updates

- Authoritative inventory: the project's official release or nightly artifact
  list for the target architecture. Use that list, not personal preference, to
  decide which packages belong here. For Libretro cores this is the aarch64
  nightly directory of the Libretro buildbot.
- Build metadata: rules files or recipe repositories that record repository
  URL, build subdirectory, makefile, build system and flags. For cores this is
  `rules.d/core-rules.sh` in `libretro-super`. Not every project is listed;
  fall back to the upstream organisation's own repositories.
- Distribution package recipes (for example Batocera `*.mk` and Lakka
  `package.mk`) often contain the only working target flags for difficult build
  systems. Distribution patch sets are useful leads but must be reviewed: many
  are obsolete, cosmetic or conflict with the policy of respecting user flags.

## Ebuild notes

- For locally maintained source packages (not covered by `sync/`), generate one
  ebuild per upstream project and pinned commit and write its Manifest from the
  downloaded archive (size and hashes). The rule about upstream `DIST` lines
  above applies to synchronised copies only.
- Patches for those local packages belong in `files/`, with a version in the
  filename and a `# Reason:` header.
- Keep shell-expanded variables and quoted values from upstream build argument
  definitions intact. Stripping tokens containing `$` or mangling escaped
  quotes breaks variables such as `EMUTYPE` and leaves invalid make arguments.
- Some eclasses pick a makefile automatically (the Libretro core eclass appends
  `-f Makefile.libretro` when present). If the real target lives elsewhere,
  override `src_compile` and invoke the right makefile explicitly.
- Set the eclass's core-name variable when the package name does not match the
  produced shared object. If upstream emits a different filename, copy it to
  the expected name in `src_install` and pass the explicit library path to the
  eclass install helper.
- Eclass EAPI requirements differ (Libretro core eclass: 7, CMake eclass: 8).
  CMake-based projects need an explicit `SRC_URI`, `mycmakeargs` and a small
  `src_install` that finds the built shared object in `BUILD_DIR`.
- GitHub archives do not contain submodule contents. When a build fails with
  missing headers from a bundled common library, repack a shallow recursive
  clone into a tarball with the same top-level directory and refresh the
  Manifest. Preserve all existing `DIST` lines when a package has extra
  archives.
- Makefiles that do `CFLAGS ?=` followed by `CFLAGS += ...` become recursive
  when Portage exports `CFLAGS`; convert the first assignment to `:=` in a
  small patch instead of overriding `CFLAGS` on the command line, which would
  suppress the makefile's own include paths.
- Old build trees may compile a native helper as part of the target build
  (MAME-family trees build `genie`). Passing cross `CC`/`CXX` makes it a target
  binary the host cannot run; use the tree's native-tool variables such as
  `OVERRIDE_CC`/`OVERRIDE_CXX`/`OVERRIDE_LD` for the target build. Some trees
  also need architecture flags such as `PTR64=1`, `ARM_ENABLED=1` and
  `LCPU=arm64`.
- Newer libc headers declare `strlcpy`/`strlcat`; old inline declarations in
  bundled utility headers need `gnu_inline` or must be translation-unit local.
  Vendored compatibility headers may remap stdio to their own API (for example
  libretro-common's `RFILE`), which can break unrelated file access; undef
  those macros locally with a documented patch.
- Very old C89 code may need `-std=gnu89`, `-fcommon` or a one-line include;
  prefer the smallest patch that fixes the concrete error.

## Repository policy

- Copy files from Gentoo Portage only when there is a target-specific change
  (a patch, an architecture fix or an intentional pin). The target system has
  Portage, so unmodified Gentoo files must not be duplicated here.
- Copy packages from other overlays: the target system does not have those
  overlays. This applies even when the copy is currently unmodified.
- Remove a legacy package only when its upstream is dormant and it cannot be
  built for the target. Still-patched or active upstream packages are kept
  under their old name.
- `profiles/updates` move entries are independent of build results: if the old
  package name disappeared and a new name exists, the entry belongs in the
  update file even when the new package fails to build.
- A metapackage needs no source directory for install tests; give it a no-op
  `src_test` if the test driver runs all phases. Comments placed inside a
  quoted `RDEPEND` string are parsed as atoms and break the package.

## Ebuild development

Editing ebuilds requires a working cross-build test suite. It is not part of
this repository: the cross toolchain container (`nsw-cross-distcc-docker`) and
the isolated `ebuild_tests/` root are in the separate buildscripts project at
https://github.com/bell07/bashscripts-switch_gentoo . Use that project to build
and install a changed ebuild against the target before treating the change as
done.

## Verification

Run from the repository root:

```sh
python3 sync/sync_overlay.py classify
python3 sync/sync_overlay.py check-patches
python3 sync/sync_overlay.py plan
```

`plan` must stay unchanged except for changes that were explicitly requested.
