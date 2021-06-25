# Copyright 1999-2020 Alexander Weber
# Copyright 1999-2021 Gavin_Darkglider / Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="arm64"
SLOT="0"

IUSE="bootstack bluetooth dock-script dracut elogind kernel-sources kernel-bin pulseaudio reboot2hekate wifi X"
HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

# Mandatory
RDEPEND+=" sys-libs/jetson-tx1-drivers[X=]"
RDEPEND+=" media-libs/joycond"

# Prebuilt switchroot bootstack files (coreboot and other SD files)
RDEPEND+=" bootstack? ( sys-boot/switchroot-bootstack )"

# Bluetooth stack
RDEPEND+=" bluetooth? ( net-wireless/bluez )"

# Script to manage dock / undock
RDEPEND+=" dock-script? ( || ( x11-misc/nintendo-switch-dock-script app-eselect/eselect-nintendo-switch-dock-handler ) )"

# dracut configuration to generate initramfs
RDEPEND+=" dracut? ( sys-boot/nintendo-switch-dracut-config )"

# Sleep fixes for elogind sleep
RDEPEND+=" elogind? ( sys-libs/nintendo-switch-sleep )"

# Switch kernel sources, merged with nvidia source
RDEPEND+=" kernel-sources? ( sys-kernel/nintendo-switch-l4t-sources )"

# Compile and install the kernel
RDEPEND+=" kernel-bin? ( sys-kernel/nintendo-switch-l4t-kernel )"

# Additional settings to audio server
RDEPEND+=" pulseaudio? ( media-libs/nintendo-switch-alsa-configs )"

# Install hekate to /lib/firmware/reboot_payload.bin
RDEPEND+=" reboot2hekate? ( sys-boot/reboot2hekate-bin )"

# Basic wifi manager
RDEPEND+=" wifi? ( net-misc/dhcpcd net-wireless/wpa_supplicant )"

# Xorg server with configuration and onscreen virtual keyboard
RDEPEND+=" X? ( x11-base/xorg-x11 x11-base/nintendo-switch-x11-configuration app-accessibility/onboard )"
