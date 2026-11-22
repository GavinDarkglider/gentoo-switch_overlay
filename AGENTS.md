# Agent notes: overlay repository

## Purpose

This repository is the Gentoo overlay for the ARM64 target. It holds profile
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
- No Git write operations by the assistant. Read-only Git commands are fine.

## Verification

Run from the repository root:

```sh
python3 sync/sync_overlay.py classify
python3 sync/sync_overlay.py check-patches
python3 sync/sync_overlay.py plan
```

`plan` must stay unchanged except for changes that were explicitly requested.
