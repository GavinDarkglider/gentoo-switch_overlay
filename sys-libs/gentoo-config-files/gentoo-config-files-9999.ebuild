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

IUSE="initramfs elogind"

BDEPEND="!!sys-boot/nintendo-switch-dracut-config
!!sys-libs/nintendo-switch-sleep"


src_install() {
	# Initramfs build with dracut
	if use initramfs; then
		insinto /usr/lib/dracut/modules.d/
		doins -r "${S}"/dracut/65NintendoSwitch

		insinto /etc/dracut.conf.d/
		doins "${S}"/dracut/NintendoSwitch.conf
	fi

	# Sleep fixes
	if use elogind; then
		exeinto /lib64/elogind/system-sleep/
		doexe elogin-sleep/nintendo-fixes.sh
	fi
}
