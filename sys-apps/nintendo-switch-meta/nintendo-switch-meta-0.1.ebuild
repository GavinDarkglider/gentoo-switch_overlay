# Copyright 1999-2022 Gavin_Darkglider / Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="arm64"
SLOT="0"

IUSE="bootstack bluetooth dock-script joystick kernel-sources kernel-bin reboot2hekate wifi X egl"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

# Mandatory
RDEPEND+=" || ( sys-libs/jetson-tx1-drivers[firmware] sys-firmware/jetson-tx1-firmware )"
RDEPEND+=" joystick? ( games-util/joycond )"
RDEPEND+=" sys-libs/gentoo-config-files" # Parts selected by USE flags

# Prebuilt switchroot bootstack files (coreboot and other SD files)
RDEPEND+=" bootstack? ( sys-boot/switchroot-bootstack )"

# Bluetooth stack
RDEPEND+=" bluetooth? ( net-wireless/bluez )"

# Script to manage dock / undock
RDEPEND+=" dock-script? ( || ( x11-misc/dock-hotplug app-eselect/eselect-nintendo-switch-dock-handler ) )"

# Switch kernel sources, merged with nvidia source
RDEPEND+=" kernel-sources? ( sys-kernel/nintendo-switch-l4t-sources )"

# Compile and install the kernel
RDEPEND+=" kernel-bin? ( sys-kernel/nintendo-switch-l4t-kernel )"

# Install hekate to /lib/firmware/reboot_payload.bin
RDEPEND+=" reboot2hekate? ( sys-boot/reboot2hekate-bin )"

# Basic wifi manager
RDEPEND+=" wifi? ( net-misc/dhcpcd net-wireless/wpa_supplicant )"

# Xorg server with configuration and onscreen virtual keyboard
RDEPEND+=" X? ( sys-libs/jetson-tx1-drivers[X] app-accessibility/onboard )"

#EGL DRM/KMS Dependencies
RDEPEND+=" egl? ( gui-libs/tegra-udrm-gbm )"
