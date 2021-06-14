# Copyright 1999-2020 Alexander Weber
# Copyright 1999-2020 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="arm64"
SLOT="0"

IUSE="+bootstack elogind +kernel-sources bluetooth +wifi X pulseaudio +reboot2hekate"
HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"

DESCRIPTION="Meta package for all required packages for Nintendo Switch"

RDEPEND+="bootstack? ("
RDEPEND+="      sys-boot/nintendo-switch-dracut-config"
RDEPEND+="      sys-boot/l4t-bootstack" # Bootstack files
RDEPEND+=" || ( sys-boot/nintendo-switch-coreboot-bin sys-boot/nintendo-switch-coreboot ) ) " # Coreboot

RDEPEND+=" kernel-sources? ( sys-kernel/nintendo-switch-l4t-sources )"

RDEPEND+=" bluetooth? ( net-wireless/bluez )"                    # Bluetooth

RDEPEND+=" wifi? ( net-misc/dhcpcd net-wireless/wpa_supplicant )" # Wifi

RDEPEND+=" X? ( x11-base/xorg-x11"                               # Xorg server
RDEPEND+="      x11-base/nintendo-switch-x11-configuration"      # xorg.conf
RDEPEND+="      app-accessibility/onboard )"                     # Onscreen virtual keyboard
RDEPEND+=" sys-libs/jetson-tx1-drivers[X=]"                      # Jetson Nano drivers

RDEPEND+="  media-libs/joycond"  # hid-joycon

RDEPEND+=" pulseaudio? ( media-libs/nintendo-switch-alsa-configs"
RDEPEND+="         X? ( || ( app-eselect/eselect-nintendo-switch-dock-handler x11-misc/nintendo-switch-dock-script ) ) )" # install if alsa and X is given

RDEPEND+=" reboot2hekate? ( sys-boot/reboot2hekate-bin )" # Install hekate to /lib/firmware/reboot_payload.bin

RDEPEND+=" elogind? ( sys-libs/nintendo-switch-sleep )" # Sleep fixes for elogind sleep
