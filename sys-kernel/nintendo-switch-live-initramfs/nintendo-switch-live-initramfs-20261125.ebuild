# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Initramfs for booting the Switch from a squashfs, built into the kernel with USE=livecd"
HOMEPAGE="https://github.com/GavinDarkglider/gentoo-switch_overlay"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm64"
IUSE="fbcondecor"

# dracut copies the programs of the system it runs on into the image, so
# this builds on arm64 only: the tools are this system's own (DEPEND, not
# BDEPEND, so a cross build never installs them on the build computer).
# Built like Lakka's initramfs, before the kernel that embeds it: no kernel
# modules in it, the kernel with USE=livecd has the drivers built in.
DEPEND="
	sys-kernel/dracut
	sys-fs/lvm2
	sys-libs/gentoo-config-files[initramfs]
	|| ( sys-libs/jetson-tx1-drivers[firmware] sys-firmware/jetson-tx1-firmware )
	fbcondecor? (
		media-gfx/splashutils[dracut,fbcondecor]
		media-gfx/splash-themes-livedvd
	)
"
# the live DVD theme, boot.scr's default on live boots: in the initramfs
# (dracut puts every installed theme in) and in the system for after it
RDEPEND="fbcondecor? ( media-gfx/splash-themes-livedvd )"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && tc-is-cross-compiler; then
		eerror "dracut puts the programs of the computer it runs on into the image,"
		eerror "so this is built on an arm64 system (on the Switch, or in an emulator"
		eerror "of it: Porthole builds it there by itself)."
		die "${PN} can't be cross-compiled"
	fi
}

src_compile() {
	# the squashfs on the SD card's FAT partition, a tmpfs over it
	# (dmsquash-live), and the Switch's own module (65NintendoSwitch)
	local modules=( base dmsquash-live overlayfs NintendoSwitch )
	use fbcondecor && modules+=( gensplash )

	dracut --no-kernel --no-hostonly --no-hostonly-cmdline --force \
		--modules "${modules[*]}" --no-compress \
		--tmpdir "${T}" \
		"${S}"/live-initramfs.cpio "${PV}" \
		|| die "dracut failed"
}

src_install() {
	# uncompressed: the kernel build compresses it with the kernel
	insinto /usr/share/${PN}
	doins live-initramfs.cpio
}
