# Overlay synchronization

This tool keeps a selected set of packages in an overlay aligned with configured
upstream repositories while preserving local changes. It runs on a regular Linux
host, not on the target device: it reads only from the configured source
repositories and writes only to the target overlay. Installed systems and source
repositories are never modified.

Sources are local checkouts, normally under `/var/db/repos`. Bring them up to
date with your usual repository sync before running this tool.

## Workflow

Inspect first; all of these commands are read-only:

```sh
python3 sync/sync_overlay.py sources        # configured sources and their state
python3 sync/sync_overlay.py classify       # how packages in the target are grouped
python3 sync/sync_overlay.py check-patches  # do local patches still apply?
python3 sync/sync_overlay.py plan           # preview changes, write nothing
```

Apply and confirm:

```sh
python3 sync/sync_overlay.py sync --yes     # write managed files and reapply patches
python3 sync/sync_overlay.py verify         # target must match the expected result
```

`sync` does not mean editing ebuilds in the overlay by hand. Managed ebuilds are
taken from the configured sources and local changes are reapplied from
`sync/patches/`; direct edits to those ebuilds are overwritten on the next run.
To keep a change, place a unified diff under `patches/ebuild/` or additional
source files under `patches/source/<PN>/`. Once present, they are applied
automatically and reused for later versions while they still apply;
`check-patches` reports when a new version-specific patch is needed. See
[Local changes and patches](#local-changes-and-patches) below.

Without `--yes`, `sync` makes no changes in a non-interactive shell.

It is good practice to preview the changes first:

```sh
python3 sync/sync_overlay.py plan
python3 sync/sync_overlay.py sync --yes
python3 sync/sync_overlay.py verify
git status
```

`--target` changes only which checkout is used; it does not create a copy.
Configuration and patch files are still read from this `sync/` directory.
Only files managed by sync are staged; the rest of the overlay is read in
place. The staged result is applied to the target atomically, file by file.
Because the target is a Git work tree, changes can be reviewed with
`git status` and reverted with `git reset --hard`.

## How packages are grouped

`classify` derives these groups from the configuration, the profile mask file
and the repositories installed under `/var/db/repos`; nothing is hard-coded,
and the counts change as sources and masks change.

- **SYNC-RELEVANT** - packages covered by a configured sync set. Their ebuilds
  are copied from a source and local changes are reapplied on every run. These
  are the only packages the tool writes.
- **VERSION-PINNED** - packages with an active entry in the profile's mask file.
  Local versions are never replaced; the mask comment is shown so the reason
  for the pin is visible.
- **UNMANAGED** - older local copies with neither a mask nor a sync rule, while
  a newer copy exists in another installed repository. Review these manually;
  the output shows both versions.
- **SWITCH-SPECIFIC** - packages that exist only in this overlay and cannot be
  found in any configured source or installed repository. They are never
  overwritten. Their descriptions are read from the `Package | Description`
  table in the overlay's main README and shown in this output; keep the table
  up to date when such a package is added or removed.

If a configured source directory is missing, its sync sets and eclass rules are
skipped with a message like `Skip sync for <source> packages, <path> missing`;
all other sources are still processed.

## What synchronization does

- Copies every ebuild present in a configured source into the target overlay.
  There is no minimum version. Optional `max_version` and `exclude_versions`
  settings can hold back versions that are known to be broken; affected
  packages then behave like version-pinned ones.
- Reapplies local changes to the copied ebuilds: keyword rewriting, ebuild
  patches, copied source patches and locally kept files.
- Rewrites `KEYWORDS` to the target architecture, preserving indentation and
  commented lines. Optional stabilisation of release ebuilds can be enabled per
  source, sync set or package, with the most specific setting winning. Live
  ebuilds and upstream keyword mirroring are left as they are.
- Copies configured eclass files and applies configured patches to them.
- Regenerates `package.unmask` below a marker line; manual entries above the
  marker are preserved.
- Writes manifests from upstream `DIST` lines only (`thin-manifests = true`).
  No network access and no `ebuild ... manifest` call are involved.
- Stages only the files managed by sync in a temporary directory. Patches must
  apply there; if anything fails, the target stays untouched.

Runs are idempotent: a second `sync` reports no changes.

## Local changes and patches

Local changes live in this directory rather than in the copied ebuilds, so they
survive the next sync:

- `patches/ebuild/<PN>[-<Version>].patch` - a unified diff applied to the
  ebuild itself.
- `patches/source/<PN>/*` - files copied into the package's `files/` directory.
  `.patch` files are also wired into `PATCHES` automatically and idempotently;
  existing references, including `eapply`, are detected so nothing is applied
  twice.
- `patches/eclass_*.patch` - patches applied to configured eclass files.

An ebuild patch is reused for every later upstream version as long as it still
applies. A new version-specific patch is needed only at the first version where
it fails; this is a maintenance decision, not a file generated per version. A
patch must only edit files that exist in every version it is applied to.

Check all patches after refreshing the source checkouts:

```sh
python3 sync/sync_overlay.py check-patches
python3 sync/sync_overlay.py check-patches <category>/<package>
```

`OK` means the selected patch still applies. `FAIL` names the ebuild and the
patch that needs to be adjusted for that version.

## Configuration

`sync.toml` defines paths, sources, eclass rules, sync sets and per-package
options:

- `sources` - where ebuilds come from. A `path` is only needed when it differs
  from `/var/db/repos/<name>`.
- `sync_sets` - which packages or globs are copied from which source, and
  whether they are unmasked.
- `eclasses` - eclass files to copy and optionally patch.
- `package_options` - deliberate local exceptions: keyword overrides, files to
  keep, and packages maintained only here.
- `settings` - unmask marker and repository suffix.

Empty sections and option blocks that contain only default values are omitted.
`auto_stabilize` is off by default and can be enabled at source, sync set or
package level; the most specific setting wins. Stabilisation applies to release
ebuilds only.
