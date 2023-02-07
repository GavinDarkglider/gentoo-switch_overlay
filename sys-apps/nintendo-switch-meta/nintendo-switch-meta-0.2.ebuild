# Copyright 1999-2022 Gavin_Darkglider / Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="arm64"
SLOT="0"

IUSE="alsa bootstack dock-script egl elogind initramfs joystick kernel-sources kernel-bin +wifi X"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

# Mandatory
RDEPEND+=" || ( sys-libs/jetson-tx1-drivers[firmware] sys-firmware/jetson-tx1-firmware )"

# Prebuilt switchroot bootstack files (coreboot and other SD files)
RDEPEND+=" bootstack? ( sys-boot/switchroot-bootstack )"

# Additional settings to audio server
RDEPEND+=" alsa? ( sys-libs/switch-l4t-configs[alsa] )"

# Script to manage dock / undock
RDEPEND+=" dock-script? ( || ( x11-misc/dock-hotplug app-eselect/eselect-nintendo-switch-dock-handler ) )"

#EGL DRM/KMS Dependencies
RDEPEND+=" egl? ( gui-libs/tegra-udrm-gbm )"

# Sleep fixes
RDEPEND+=" elogind? ( sys-libs/gentoo-config-files[elogind] )"

# dracut configuration to generate initramfs
RDEPEND+=" initramfs? ( sys-libs/gentoo-config-files[initramfs] )"

# Joycons
RDEPEND+=" joystick? ( =games-util/joycond-9999 )"

# Switch kernel sources, merged with nvidia source
RDEPEND+=" kernel-sources? ( sys-kernel/nintendo-switch-l4t-sources )"

# Compile and install the kernel
RDEPEND+=" kernel-bin? ( sys-kernel/nintendo-switch-l4t-kernel )"

# Basic wifi manager
RDEPEND+=" wifi? ( sys-libs/switch-l4t-configs[brcm] )"

# Xorg server with configuration and onscreen virtual keyboard
RDEPEND+=" X? ( sys-libs/jetson-tx1-drivers[X] app-accessibility/onboard sys-libs/switch-l4t-configs[X] )"
