# Copyright 2022 Alexander Weber, Gavin Darkglider
# Distributed under the terms of the GNU General Public License v3

EAPI=7

DESCRIPTION="Misc confirugation files for Gentoo on Nintendo Switch"
HOMEPAGE="https://gitlab.com/bell07/gentoo-config-files"

COMMIT="87e2b47443ee3a691ff629954095cca8f323170f"
SRC_URI="$HOMEPAGE/-/archive/${COMMIT}/${PN}.zip -> ${P}.zip"

RESTRICT="mirror"

S="${WORKDIR}/gentoo-config-files-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="initramfs +installkernel elogind"

BDEPEND="!!sys-boot/nintendo-switch-dracut-config
!!sys-libs/nintendo-switch-sleep"

# dracut script copy xxd binary into initramfs
DEPEND="initramfs? ( app-editors/vim-core )
		installkernel? ( dev-embedded/u-boot-tools )"

src_install() {
	# Initramfs build with dracut
	if use initramfs; then
		insinto /usr/lib/dracut/modules.d/
		doins -r "${S}"/dracut/65NintendoSwitch

		insinto /etc/dracut.conf.d/
		doins "${S}"/dracut/NintendoSwitch.conf
	fi

	# installkernel enhancements
	if use installkernel; then
		exeinto /etc/kernel/preinst.d
		doexe installkernel/80-switch-kernel-dts.install

		exeinto /etc/kernel/postinst.d
		doexe installkernel/80-set-switch-symlinks-and-clearup.install

		into /
		dosbin installkernel/mkdtboimg.py
	fi

	# Sleep fixes
	if use elogind; then
		exeinto /lib64/elogind/system-sleep/
		doexe elogin-sleep/nintendo-fixes.sh
	fi
}
