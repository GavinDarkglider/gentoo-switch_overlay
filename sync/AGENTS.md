# Agent notes: synchronisation tool

`sync_overlay.py` is a declarative, offline synchroniser. It reads only
configured sources and writes only the target overlay. Manifests come from the
upstream `DIST` lines because the overlay uses `thin-manifests = true`; no
network access and no `ebuild ... manifest` call are involved.

## Commands

All commands are read-only except `sync`:

```sh
python3 sync/sync_overlay.py sources        # configured sources and their state
python3 sync/sync_overlay.py classify       # package groups and reasons
python3 sync/sync_overlay.py check-patches  # do local patches still apply?
python3 sync/sync_overlay.py plan           # preview changes
python3 sync/sync_overlay.py sync --yes     # apply changes
python3 sync/sync_overlay.py verify         # compare target with expected files
```

Use `--target <checkout>` to select a different overlay. Configuration and
patches are always read from this `sync/` directory, not from that checkout.

## Safety model

- Sources are read-only; the target is touched only by `sync`.
- Only files managed by sync are staged in a temporary directory; the target
  is not copied. Patches must apply there; on failure the target stays
  untouched.
- Changed files are applied atomically; no `rm -rf` is run in the target.
- The target is a Git work tree: review with `git status` and revert with
  `git reset --hard`.
- A missing source is skipped with
  `Skip sync for <source> packages, <path> missing`; other sources continue.
- `sync` is idempotent: a second run reports no changes.

## Configuration (`sync.toml`)

- `[paths]` holds `target`, `patches`, `unmask` and `mask`.
- A source needs `path` only when it is not `/var/db/repos/<name>`. Rules that
  reference an undeclared source use that default implicitly.
- Empty sections and option blocks containing only defaults are omitted.
- `sync_sets` define packages or globs, their source and optional unmasking.
- `eclasses` define eclass files to copy and optionally patch.
- `package_options` hold deliberate exceptions: `keyword_override`,
  `preserve_local_files` and `switch_specific`.
- `settings` hold the unmask marker and repository suffix.
- There are no `ebuild_patches` or `source_files` switches; patch discovery is
  automatic.
- `auto_stabilize` applies to release ebuilds only, never to live (9999) ebuilds
  or mirrored upstream keywords. It is off by default and resolved at package >
  sync set > source level. Sources that do not opt in mirror upstream keywords.

## Patches

- `patches/ebuild/<PN>[-<Version>].patch` - unified diff applied to an ebuild.
- `patches/source/<PN>/*` - copied into `files/`; `.patch` files are also wired
  into `PATCHES` idempotently. Existing references, including `eapply`, are
  detected so nothing is applied twice.
- `patches/eclass_*.patch` - patches for configured eclass files.
- One ebuild patch is reused for every later version while it still applies.
  Add a version-specific patch only at the first version where it fails.
- A patch must only edit files that exist in every version it is applied to.
- `check-patches` covers every synced package with an ebuild patch. `OK` means
  the selected patch applies; `FAIL` names the ebuild and patch to update.

## Keywords, unmask and classify

- `KEYWORDS` are rewritten to the target architecture, preserving indentation
  and commented lines and distinguishing stable from testing keywords.
- `package.unmask` is regenerated below a marker; manual entries above it are
  preserved.
- `classify` derives its groups from configuration, the profile mask and the
  repositories under `/var/db/repos`. Masked packages show the pinned local
  version(s) and the mask comment. Unmanaged packages show local and newer
  versions; only active masks count as pinned.
- Descriptions for SWITCH-SPECIFIC packages are read from the `Package |
  Description` table in the overlay's main README by
  `read_package_descriptions()`. Update that table when such a package is added
  or removed.

## Verification checklist

- `check-patches` ends with `PATCH CHECK OK`.
- `plan` differs from the previous state only by explicitly requested changes.
- `sync --yes` followed by `verify` ends with `VERIFY OK`; `git status` shows
  the applied changes.
- Remove temporary copies and any `__pycache__` created by direct imports.
