# Copyright 2022 Alexander Weber, Gavin Darkglider
# Distributed under the terms of the GNU General Public License v3

EAPI=7

DESCRIPTION="Misc confirugation files for Gentoo on Nintendo Switch"
HOMEPAGE="https://gitlab.com/bell07/gentoo-config-files"

COMMIT="512d753a0186f821974f584d5b171701a2430c74"
SRC_URI="$HOMEPAGE/-/archive/${COMMIT}/${PN}.zip -> ${PN}-"${COMMIT}".zip"

RESTRICT="mirror"

S="${WORKDIR}/gentoo-config-files-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="initramfs +installkernel elogind"

BDEPEND="!!sys-boot/nintendo-switch-dracut-config
!!sys-libs/nintendo-switch-sleep"

# dracut script copy xxd binary from vim-core into initramfs
RDEPEND="initramfs? ( sys-kernel/dracut app-editors/vim-core )
		installkernel? ( sys-kernel/installkernel[nsw] dev-embedded/u-boot-tools )"

PATCHES=(
	# take the nx-plat.dtimg that make dtbs builds (pack one only when missing),
	# and name the uImage after the kernel version
	"${FILESDIR}"/80-switch-kernel-dts-use-kernel-dtimg.patch
	# install the error screen as /fatal.raw, and the tar, gzip, timeout
	# and date the hooks run
	"${FILESDIR}"/65NintendoSwitch-install-what-the-hooks-use.patch
	# MACs: the kernel takes them from the device tree; the firmware file
	# edits stay as a fallback on live boots only
	"${FILESDIR}"/65NintendoSwitch-firmware-macs-on-live-boots-only.patch
)

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
		dobin installkernel/mkdtboimg.py

		exeinto /usr/lib/kernel/preinst.d
		doexe installkernel/80-switch-kernel-dts.install

		exeinto /usr/lib/kernel/postinst.d
		doexe installkernel/80-set-switch-symlinks-and-clearup.install
	fi

	# Sleep fixes
	if use elogind; then
		exeinto /lib64/elogind/system-sleep/
		doexe elogin-sleep/nintendo-fixes.sh
	fi
}
