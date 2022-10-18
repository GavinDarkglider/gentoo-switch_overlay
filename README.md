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
  [1]   default/linux/arm64/17.0 (stable)
  [2]   default/linux/arm64/17.0/desktop (stable)
  [3]   default/linux/arm64/17.0/desktop/gnome (stable)
  [4]   default/linux/arm64/17.0/desktop/gnome/systemd (stable)
  [5]   default/linux/arm64/17.0/desktop/plasma (stable)
  [6]   default/linux/arm64/17.0/desktop/plasma/systemd (stable)
  [7]   default/linux/arm64/17.0/desktop/systemd (stable)
  [8]   default/linux/arm64/17.0/developer (stable)
  [9]   default/linux/arm64/17.0/systemd (stable)
  [10]  default/linux/arm64/17.0/big-endian (exp)
  [11]  default/linux/arm64/17.0/musl (exp)
  [12]  default/linux/arm64/17.0/musl/hardened (exp)
  [13]  switch:nintendo_switch/17.0 (stable)
  [14]  switch:nintendo_switch/17.0/desktop (stable)
  [15]  switch:nintendo_switch/17.0/desktop/plasma (exp)
  [16]  switch:nintendo_switch/17.0/desktop/plasma/systemd (exp)
  [17]  switch:nintendo_switch/17.0/desktop/systemd (exp)
  [18]  switch:nintendo_switch/17.0/desktop/gnome (exp)
  [19]  switch:nintendo_switch/17.0/desktop/gnome/systemd (exp)
  [20]  switch:nintendo_switch/17.0/desktop/cuda (exp)
  [21]  switch:nintendo_switch/17.0/desktop/cuda/plasma (exp)
  [22]  switch:nintendo_switch/17.0/desktop/cuda/plasma/systemd (exp)
  [23]  switch:nintendo_switch/17.0/desktop/cuda/systemd (exp)
  [24]  switch:nintendo_switch/17.0/desktop/cuda/gnome (exp)
  [25]  switch:nintendo_switch/17.0/desktop/cuda/gnome/systemd (exp)
```
The `switch:nintendo_switch/17.0/desktop`is recommended, since most tested by me. The cuda profiles are for further use and just forces older gcc atm.

Using the profile you do not need to setup the usual settings like CFLAGS because included in [make.defaults](https://gitlab.com/bell07/gentoo-switch_overlay/-/blob/master/profiles/nintendo_switch/make.defaults)
Of course you can set the settings to your make.conf and leave the profile.

```
eselect profile set switch:nintendo_switch/17.0/desktop
```

## Installation of packages
Should be more simple than it probably is. This is still very much experimental, and most things havnt been tested properly.

## Available packages
Mainly stuff that is needed to run l4t on the switch with as much hardware support as possible. A few other things I might decide I want to run on my switch.
Look through the overlay, and see what is there.

## Meta Package sys-apps/nintendo-switch-meta
The starting point to install the basic files is the sys-apps/nintendo-switch-meta package, that just push other packages as dependency.
The package have the next USE flags for enabeling/disabeling things:
| USE | packages | Explanation
| ------ | ------ | ------
| bootstack | sys-boot/switchroot-bootstack | Installs precompiled bootstack files (coreboot.rom, boot.scr, uenv.txt and more) into /usr/share/sdcard1. The ebuild supports to install the files directly to the vfat partition. Disable the flag if you like to manage this files byself
| bluetooth | net-wireless/bluez | Nothing special. Just install bluez, required for joycons
| dock-script | x11-misc/nintendo-switch-dock-script or app-eselect/eselect-nintendo-switch-dock-handler | They are two scripts to manage the dock usage (swap screen and audio)
| kernel-sources | sys-kernel/nintendo-switch-l4t-sources | Install l4t kernel sources, patched with nvidia sources inside. Use this package if you like to compile your kernel directly on the switch
| kernel-bin | sys-kernel/nintendo-switch-l4t-kernel | Install the l4t kernel and some sources to compile external modules. USe this package if you use qemu build enviroment and binary packages
|-kernel-sources -kernel-bin | | Of course you can disable kernel-sources and kernel-bin, and compile your kernel however you like
| reboot2hekate | sys-boot/reboot2hekate-bin | Install hekate as /lib/firmware/reboot_payload.bin to reboot back into hekate
| wifi | net-misc/dhcpcd net-wireless/wpa_supplicant | Nothing special, just basic software for wifi
| X | x11-base/xorg-x11, app-accessibility/onboard | Install all required for X-Server, including config and onscreen keyboard "onboard"
| | sys-libs/jetson-tx1-drivers and games-util/joycond | The both packages (driver and joycon management) are pushed unconditionally
| | sys-libs/gentoo-config-files | All additional required configuration files

## Updating packages
Version ebuilds will be updated automatically in the usual manner of installed packages.

Live ebuilds will not be automatically updated when updating your installed packages, but can be updated by running smart-live-rebuild (if that command is not available, it can be installed by running emerge app-portage/smart-live-rebuild).

## Getting help

Feel free to leave a bug report on gitlab, and I will see what I can do to fix the issues.
Good luck!
