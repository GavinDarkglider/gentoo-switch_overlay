# Overlay synchronization (Python)

The script runs **outside** the Switch system, reads only from the source
repositories and writes only to the target overlay (normally this repository).

## Prerequisites

Source checkouts are read-only; update them as needed before running the sync.
Repositories under `/var/db/repos` are used directly. You can check the state
read-only with:

```sh
python3 sync/sync_overlay.py sources
```

Then:

```sh
python3 sync/sync_overlay.py classify          # show package groups
python3 sync/sync_overlay.py check-patches     # test all ebuild patches
python3 sync/sync_overlay.py plan              # show changes, write nothing
python3 sync/sync_overlay.py sync --yes        # apply the synchronization
python3 sync/sync_overlay.py verify            # verify the result
```

**Always test on a copy:**

```sh
TESTDIR="$(mktemp -d)"
cp -a . "$TESTDIR/overlay"
rm -rf "$TESTDIR/overlay/.git"
python3 sync/sync_overlay.py --target "$TESTDIR/overlay" plan
python3 sync/sync_overlay.py --target "$TESTDIR/overlay" sync --yes
python3 sync/sync_overlay.py --target "$TESTDIR/overlay" verify
```

With `--target`, the configuration is still resolved relative to the real
`sync/` directory; only pass `--config ...` if you intentionally want a
different configuration. Before every `sync`, a full backup of the target is
created in the system temporary directory as `switch-overlay-backup-*`.
Without `--yes`, nothing is written in a non-interactive shell.

## Package groups (current configuration)

- **sync-relevant (152):** system packages with local kernel patches, one
  accessibility package, the Libretro/RetroArch family and `dev-lang/rgbds`,
  plus the eclass files configured in `sync.toml`.
- **version-pinned (22):** e.g. ALSA/PulseAudio, X.org, Mesa, `linux-headers`,
  `systemd-utils`, `xwayland`, GTK/GStreamer. These are pinned via
  `profiles/nintendo_switch/package.mask`. They are **never** overwritten.
- **unmanaged (10):** old local copies without a mask or sync set, e.g.
  `gnome-extra/nm-applet`, `gui-libs/egl-gbm`, `media-video/ffmpeg-chromium`,
  `sci-ml/caffe2`, `sci-ml/pytorch`, `x11-misc/touchegg` and `media-libs/babl`.
  The reason names the repository with the newer version; review manually
  before changing anything.
- **Switch-specific (23):** e.g. the L4T kernel/sources, bootstack, U-Boot,
  ATF, `nintendo-switch-meta`, Jetson drivers/firmware, Tegra components and
  splash themes. These are **never** overwritten.

The list is not hard-coded; `classify` computes it from the configuration, the
profile masks and the source repositories. Masked packages show their pinned
local version and the corresponding comment block from `package.mask`, so the
reason for the pin is visible. It also scans other repositories under
`/var/db/repos`; unmasked packages with an upstream copy there are listed as
**unmanaged**, with the local and newer versions shown in the reason. Only
packages with an active `package.mask` entry remain pinned.

## Behaviour and safety

- If an overlay source is missing, its sync set and eclass rules are skipped
  with a message such as `Skip sync for <source> packages, <path> missing`.
  Other sources are still synchronised.
- Everything is written to a staging copy first; patches must apply cleanly
  there, otherwise the target is left untouched. A backup is created
  afterwards, then changed files are applied atomically. No `rm -rf` in the
  target.
- Manifests are written offline from the upstream `DIST` lines
  (`thin-manifests = true`); no `ebuild ... manifest` and no network access.
- Patch selection uses upstream version comparison instead of alphabetical order
  (`glibc-2.43.patch` is correctly applied to `2.44-r5` until a version needs
  its own patch).
- `KEYWORDS` rewriting preserves indentation and commented-out lines and
  correctly distinguishes stable from testing keywords. Deliberate deviations
  live in `sync.toml` (`package_options`) instead of being lost.
- Patches copied from `patches/source/<PN>/*.patch` are wired into `PATCHES` or
  `PATCHES+=` automatically and idempotently. Existing references (including
  `eapply`) are detected, so mixed patch files keep working. Ebuild patch files
  that only add a `PATCHES` entry have been removed from
  `sync/patches/ebuild/`; mixed patch files have been reduced to their
  non-`PATCHES` changes.
- `package.unmask` is regenerated only below the marker; manual entries above
  it are preserved and use `::switch`.
- `plan`, `verify`, `classify`, `check-patches` and `sources` are read-only.
- `sync --yes` is idempotent: a second run reports 0 changes.

## Configuration

`sync.toml` contains the source options, the packages/globs to synchronize,
eclass rules and `package_options` for deliberate local deviations. A source
only needs an explicit `path` when it is not `/var/db/repos/<name>`; if an
eclass or sync set references an undeclared source, that default is used
implicitly. Empty sections and option blocks with no parameters are omitted.
Every ebuild that exists in a configured source is copied into the overlay;
there is no minimum version. `max_version` is optional and only used when newer versions
are known to be broken: versions above it are skipped and stay at their current
overlay state, which turns them into version-pinned packages.
`exclude_versions` remains available for individual known-bad versions.
`auto_stabilize` can be set on a source, a sync set or a package option; the
most specific value wins (package > sync set > source), and the default is
`false`. When enabled, a testing-only release ebuild gets `KEYWORDS="arm64"`
instead of `~arm64`; live (9999) ebuilds and upstream keyword mirroring are
never changed. One configured source opts in, so `onboard` needs no
`keyword_override`. Other sources mirror the upstream keywords unchanged.

`keyword_override` and `preserve_local_files` are used for
`games-emulation/cannonball-libretro`; `preserve_local_files` alone is used for
`app-accessibility/onboard`.
`switch_specific = true` marks local forks (currently `games-util/joycond`) so
they are reported as Switch-specific even when an upstream package with the
same name exists. Files under `files/` that exist only in the overlay are
preserved as well. There is no `sync/patches/source/onboard/` directory: the
start-in-tray patch is applied by an explicit `eapply` because both `gnome2`
and `distutils-r1` call `default`, so a generic `PATCHES` entry would apply it
twice.

An ebuild patch is applied whenever `sync/patches/ebuild/<PN>[-<Version>].patch`
exists for a synced package, and files from `sync/patches/source/<PN>/` are
copied whenever that directory exists. No extra options are needed.

All patch sources live inside `sync/patches/`:

- `sync/patches/ebuild/<PN>[-<Version>].patch`
- `sync/patches/source/<PN>/*`
- `sync/patches/eclass_kernel_build.patch`

An ebuild patch stays in use for every later version as long as it still
applies cleanly. A new `<PN>-<version>.patch` is only added at the first version
where the previous patch fails. This is a one-time maintenance decision per
affected package, not a generated file per version.

After a Portage sync, check all ebuild patches at once:

```sh
python3 sync/sync_overlay.py check-patches
python3 sync/sync_overlay.py check-patches sys-libs/glibc
```

`OK` means the selected patch still applies. `FAIL` names the ebuild and the
patch that must be replaced or supplemented for that version. The check covers
every synced package that has an ebuild patch, not only glibc.
