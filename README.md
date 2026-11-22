# gentoo-switch_overlay

## Info

Repoman status: Build Status

This overlay provides ebuilds and basic settings for Nintendo Switch gentoo installation. The instructions below document how to add and use this overlay with Portage and how to use the profile and meta-package. (If you prefer to use the overlay differently than below, feel free.)

### Adding using repos.conf

To add this overlay to Portage in repos.conf, here is example configuration for it:
```
[switch]
priority = 50
location = /var/db/repos/gentoo-switch_overlay
sync-type = git
sync-uri = https://gitlab.com/bell07/gentoo-switch_overlay.git
auto-sync = yes
clone-depth = 0
```
See the Gentoo wiki page at https://wiki.gentoo.org/wiki//etc/portage/repos.conf for how to use this. If auto-sync is set to yes, as it is in this example, the repository should be automatically updated when you update your system.

## Using the profile basic settings
The overlay provides profiles that enhances the gentoo portage profile by NSW specific settings.
```
# eselect profile list
Available profile symlink targets:
  [55]  switch:nintendo_switch/17.0 (stable)
  [56]  switch:nintendo_switch/17.0/desktop (stable)
  [57]  switch:nintendo_switch/17.0/desktop/plasma (exp)
  [58]  switch:nintendo_switch/17.0/desktop/plasma/systemd (exp)
  [59]  switch:nintendo_switch/17.0/desktop/systemd (exp)
  [60]  switch:nintendo_switch/17.0/desktop/gnome (exp)
  [61]  switch:nintendo_switch/17.0/desktop/gnome/systemd (exp)
  [62]  switch:nintendo_switch/17.0/desktop/cuda (exp)
  [63]  switch:nintendo_switch/17.0/desktop/cuda/plasma (exp)
  [64]  switch:nintendo_switch/17.0/desktop/cuda/plasma/systemd (exp)
  [65]  switch:nintendo_switch/17.0/desktop/cuda/systemd (exp)
  [66]  switch:nintendo_switch/17.0/desktop/cuda/gnome (exp)
  [67]  switch:nintendo_switch/17.0/desktop/cuda/gnome/systemd (exp)
  [68]  switch:nintendo_switch/23.0 (stable)
  [69]  switch:nintendo_switch/23.0/desktop (stable)
  [70]  switch:nintendo_switch/23.0/desktop/gnome (stable)
  [71]  switch:nintendo_switch/23.0/desktop/gnome/systemd (exp)
  [72]  switch:nintendo_switch/23.0/desktop/plasma (stable)
  [73]  switch:nintendo_switch/23.0/desktop/plasma/systemd (exp)
  [74]  switch:nintendo_switch/23.0/desktop/systemd (exp)
  [75]  switch:nintendo_switch/23.0/split-usr (stable)
  [76]  switch:nintendo_switch/23.0/split-usr/desktop (stable)
  [77]  switch:nintendo_switch/23.0/split-usr/desktop/gnome (stable)
  [78]  switch:nintendo_switch/23.0/split-usr/desktop/gnome/systemd (exp)
  [79]  switch:nintendo_switch/23.0/split-usr/desktop/plasma (stable)
  [80]  switch:nintendo_switch/23.0/split-usr/desktop/plasma/systemd (exp)
  [81]  switch:nintendo_switch/23.0/split-usr/desktop/systemd (exp)

```
The `switch:nintendo_switch/23.0/desktop`is recommended, since most tested by me. The 17.0 are deprecated by upstream. The cuda profiles are for further use and just forces older gcc atm.
Pls. note, the 23.0 profiles are merged-usr by default, so in case of upgrade from previously 17.0, you need to migrate merged-usr first or use the split-usr profiles.
Read the file `/var/db/repos/gentoo/profiles/default/linux/arm64/17.0/deprecated` for more details.

Using the profile you do not need to setup the usual settings like CFLAGS because included in [make.defaults](https://gitlab.com/bell07/gentoo-switch_overlay/-/blob/master/profiles/nintendo_switch/make.defaults)
Of course you can set the settings to your make.conf and leave the profile.

```
eselect profile set switch:nintendo_switch/23.0/desktop
```
## Installation
The full guide from is decribed in [bootstrap.md](bootstrap.md). 
Abbreviations exists. It is possible to use precompiled stage3 from [bell07's releases](https://github.com/bell07/bashscripts-switch_gentoo/releases) .
It is possible to do full installation using Switch without PC. An other running Linux is required as live medium in this case.
In any case Gentoo knowledge is required to do the Gentoo installation on the switch.

## Installation of packages
Should be more simple than it probably is. This is still very much experimental, and most things havnt been tested properly.

## Available packages
Mainly stuff that is needed to run l4t on the switch with as much hardware support as possible. A few other things I might decide I want to run on my switch.
Look through the overlay, and see what is there.

Packages fall into several groups: synchronised upstream copies, version-pinned packages, unmanaged local copies and packages maintained only here. Run `python3 sync/sync_overlay.py classify` for the live breakdown and the reasons.

### Locally maintained packages

The packages below exist only in this overlay. They are never overwritten by the synchronisation tool, which reports them as SWITCH-SPECIFIC. The descriptions are also used in the `classify` output, so keep this table up to date.

| Package | Description |
| --- | --- |
| `app-text/bookworm` | Simple ebook reader |
| `dev-libs/cudnn-frontend` | C++ wrapper for the cuDNN backend API |
| `games-util/joycond` | Joy-Con pairing daemon using hid-nintendo evdev devices |
| `gui-libs/tegra-udrm-gbm` | GBM backend loader wrapper for Tegra UDRM/Mesa |
| `gui-wm/mithraui` | Gamepad and touch first console desktop |
| `media-gfx/fbsplash-theme-natural-gentoo` | Natural Gentoo framebuffer splash theme |
| `media-gfx/splash-themes-gentoo` | Classic Gentoo framebuffer splash themes |
| `media-gfx/splash-themes-livecd` | Framebuffer splash themes from Gentoo LiveCD releases |
| `media-gfx/splash-themes-livedvd` | Framebuffer splash theme from the Gentoo LiveDVD |
| `media-gfx/splashutils` | Framebuffer splash and console decoration utilities |
| `media-libs/vk_layer_tegra_dc_present` | Vulkan layer that fixes tearing on L4T |
| `sys-apps/nintendo-switch-meta` | Meta package for the core system setup |
| `sys-boot/cbfstool` | Tools for manipulating coreboot CBFS images |
| `sys-boot/nintendo-switch-u-boot` | U-Boot source tree for the Switch |
| `sys-boot/switch-atf` | Trusted Firmware-A bl31 for the Switch |
| `sys-boot/switchroot-bootstack` | Bootstack files built from source |
| `sys-firmware/jetson-tx1-firmware` | Firmware-only package for the Jetson TX1 |
| `sys-kernel/nintendo-switch-l4t-kernel` | Kernel and module build support from the L4T community tree |
| `sys-kernel/nintendo-switch-l4t-sources` | Kernel sources from the L4T community tree |
| `sys-libs/gentoo-config-files` | Miscellaneous Gentoo configuration files |
| `sys-libs/jetson-tx1-drivers` | Accelerated graphics drivers for the Jetson TX1 |
| `sys-libs/switch-l4t-configs` | L4T device configuration files |
| `x11-apps/iio-sensor-proxy` | D-Bus proxy for IIO sensors |

## Meta Package sys-apps/nintendo-switch-meta
The starting point to install the basic files is the sys-apps/nintendo-switch-meta package, that just push other packages as dependency.
The package have the next USE flags for enabeling/disabeling things. The ebuild is authoritative for the current list:

| USE | packages | Explanation
| ------ | ------ | ------
| | sys-libs/jetson-tx1-drivers[firmware] or sys-firmware/jetson-tx1-firmware | Firmware is mandatory, either drivers or firmware only package
| alsa | sys-libs/switch-l4t-configs[alsa]  | Install alsa ucm configuration to get audio working
| bootstack (default) | sys-boot/switchroot-bootstack | Installs boot files into /usr/share/sdcard1. The ebuild supports to install the files directly to the vfat partition.
| dock-handler | sys-libs/switch-l4t-configs[dock-handler] | Script to manage the dock/undock events (swap screen and audio)
| gbm | gui-libs/tegra-udrm-gbm | DRM/KMS Dependencies (GBM backend for EGL)
| elogind | sys-libs/gentoo-config-files[elogind] | Deep Sleep and resume fixes, managed by elogind
| initramfs | sys-libs/gentoo-config-files[initramfs] | Installs configuration for dracut, for building initramfs. Note, the initramfs needs to be packed for u-boot using dev-embedded/u-boot-tools.
| joystick | games-util/joycond | Combined joycons manager
| kernel-sources | sys-kernel/nintendo-switch-l4t-sources | Install l4t kernel sources, patched with nvidia sources inside. Use this package if you like to compile your kernel directly on the switch
| kernel-bin | sys-kernel/nintendo-switch-l4t-kernel | Install the l4t kernel and some sources to compile external modules. USe this package if you use qemu build enviroment and binary packages
|-kernel-sources -kernel-bin | | Of course you can disable kernel-sources and kernel-bin, and compile your kernel however you like
| vulkan | media-libs/vk_layer_tegra_dc_present | Vulkan layer fixing tearing on L4T
| wifi (default) | sys-libs/switch-l4t-configs[brcm] | Fimrware settings for wifi. Additional networking manager, like wpa_supplicant
| X | sys-libs/jetson-tx1-drivers[X] app-accessibility/onboard or sys-libs/switch-l4t-configs[X] | Install all required for X-Server, including config and onscreen keyboard "onboard"

## Updating packages
Version ebuilds will be updated automatically in the usual manner of installed packages.

Live ebuilds will not be automatically updated when updating your installed packages, but can be updated by running smart-live-rebuild (if that command is not available, it can be installed by running emerge app-portage/smart-live-rebuild).

## Getting help

Feel free to leave a bug report on gitlab, and I will see what I can do to fix the issues.
Good luck!
