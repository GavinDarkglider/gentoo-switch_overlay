# Copyright 2022 Alexander Weber, Gavin Darkglider
# Distributed under the terms of the GNU General Public License v3

EAPI=7

inherit git-r3

DESCRIPTION="Misc confirugation files for Gentoo on Nintendo Switch"
HOMEPAGE="https://gitlab.com/bell07/gentoo-config-files"
EGIT_REPO_URI="https://gitlab.com/bell07/gentoo-config-files"
EGIT_BRANCH="main"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="alsa initramfs +wifi X"

BDEPEND="!!sys-boot/nintendo-switch-dracut-config
!!sys-libs/nintendo-switch-sleep"


src_install() {
	# Alsa
	if use alsa; then
		insinto /usr/share/alsa/ucm2/tegra-snd-t210r
		doins alsa-ucm2/HiFi.conf
		doins alsa-ucm2/tegra-snd-t210r.conf
	fi

	# Initramfs build with dracut
	if use initramfs; then
		insinto /usr/lib/dracut/modules.d/
		doins -r "${S}"/dracut/65NintendoSwitch

		insinto /etc/dracut.conf.d/
		doins "${S}"/dracut/NintendoSwitch.conf
	fi

	# Missed broadcom firmware file
	if use wifi; then
		insinto lib/firmware/brcm
		newins wireless-nvram/brcmfmac4356-pcie.txt brcmfmac4356A3-pcie.txt
	fi

	# X server configurations
	if use X; then
		insinto /etc/X11/
		doins -r xorg.conf.d
	fi

	# Udev-Rules
	insinto /lib/udev/rules.d
	doins udev-rules/99-switch-touchscreen.rules

	# Sleep fixes
	exeinto /lib64/elogind/system-sleep/
	doexe elogin-sleep/nintendo-fixes.sh
}
