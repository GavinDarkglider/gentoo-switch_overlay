# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="~arm64"
SLOT="0"

IUSE="kernel-sources hid-joycon kali_patches lakka_patches -lp0 bluetooth +wifi X vulkan +egl pulseaudio"
HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

RDEPEND+=" sys-boot/nintendo-switch-coreboot-bin" # Coreboot image and boot chain updaters
RDEPEND+=" dev-embedded/u-boot-tools"             # mkimage to update bootloader

RDEPEND+=" kernel-sources? ("
RDEPEND+="      sys-kernel/nintendo-switch-l4t-sources[hid-joycon=,kali_patches=,lakka_patches=,lp0=]" # Working kernel
RDEPEND+="      sys-firmware/nintendo-switch-firmware sys-kernel/linux-firmware )"                     # Required firmware

RDEPEND+=" bluetooth? ( net-wireless/bluez )"                    # Bluetooth

RDEPEND+=" wifi? ( net-misc/dhcpcd net-wireless/wpa_supplicant )" # Wifi

RDEPEND+=" X? ( x11-base/xorg-x11"                               # Xorg server
RDEPEND+="      x11-base/nintendo-switch-x11-configuration"      # xorg.conf
RDEPEND+="      app-accessibility/onboard"                       # Onscreen virtual keyboard
RDEPEND+="      x11-drivers/jetson-tx1-drivers[vulkan=,egl=] )"  # Jetson Nano xorg drivers

RDEPEND+=" hid-joycon? ( media-libs/joycond )"  # hid-joycon

RDEPEND+=" pulseaudio? ( media-libs/nintendo-switch-alsa-configs"
RDEPEND+="         X? ( app-eselect/eselect-nintendo-switch-dock-handler ) )" # install if alsa and X is given
