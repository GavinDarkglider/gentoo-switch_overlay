# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="~arm64"
SLOT="0"

IUSE="hid-joycon +bluetooth +wifi vulkan +egl kali_patches lakka_patches -lp0 kernel-sources"
HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

RDEPEND+=" app-accessibility/onboard"                            # Onboard keyboard
RDEPEND+=" app-editors/nano"                                     # should not be replaced by VI
RDEPEND+=" wifi? ( net-misc/dhcpcd net-wireless/wpa_supplicant net-wireless/iw net-wireless/wireless-tools )" # Wifi
REDPEND+=" bluetooth? ( bluetooth net-wireless/bluez )"           # Bluetooth 
RDEPEND+=" kernel-sources? ( sys-kernel/nintendo-switch-l4t-sources ) sys-firmware/nintendo-switch-firmware"               # Working kernel
RDEPEND+=" sys-boot/nintendo-switch-coreboot-bin"                # Coreboot image and boot chain updaters
RDEPEND+=" dev-embedded/u-boot-tools"                            # mkimage to update bootloader
RDEPEND+=" x11-base/xorg-x11"                                    # Xorg server
RDEPEND+=" x11-drivers/jetson-tx1-drivers"                       # Jetson Nano xorg drivers
RDEPEND+=" app-accessibility/onboard"                            # Virtual keyboard
RDEPEND+=" hid-joycon? ( media-libs/joycond )"                   # hid-joycon
