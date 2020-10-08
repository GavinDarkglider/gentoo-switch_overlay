EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://github.com/Linux-4-Switch/bootstack"
DESCRIPTION="Precompiled coreboot file"

inherit git-r3 sdcard-mount

EGIT_REPO_URI="https://github.com/Linux-4-Switch/bootstack"
EGIT_BRANCH="master"
EGIT_SUBMODULES=()

DEPEND="sys-boot/cbfstool
		sys-boot/nintendo-switch-u-boot"

src_compile() {
	einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
	einfo "   ${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
	sh "${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf || die "patching coreboot failed"
}

src_install() {
	dodir "${SDCARD_DESTDIR}"/switchroot/gentoo
	cd "${S}"/src
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins coreboot.rom

	dobin "${FILESDIR}"/update-coreboot.sh
	dobin "${FILESDIR}"/update-boot.scr.sh

	insinto /etc
	doins "${FILESDIR}/nintendo-switch-boot.txt"
}

pkg_config() {
	einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
	einfo "${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
	"${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf  || die "patching coreboot failed"

	einfo "Update ${SDCARD_DESTDIR}"/switchroot/gentoo/boot.scr
	einfo "${ROOT}"/usr/bin/update-boot.scr.sh "${SDCARD_DESTDIR}"/switchroot/gentoo/boot.scr
	"${ROOT}"/usr/bin/update-boot.scr.sh "${SDCARD_DESTDIR}"/switchroot/gentoo/boot.scr || die "updating boot.scr failed"

	sdcard-mount_pkg_setup

	if [[ -n "${SDCARD_MOUNT_POINT}" ]] ; then
		cp -va "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${SDCARD_MOUNT_POINT}"/switchroot/gentoo || die "Pls. check if right medium mounted"
		cp -va "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/boot.scr "${SDCARD_MOUNT_POINT}"/switchroot/gentoo || die "Pls. check if right medium mounted"
	fi
}

pkg_postinst() {
	einfo "Update the coreboot.rom and boot.scr using "
	einfo "   ebuild /var/db/repos/switch_overlay/sys-boot/nintendo-switch-coreboot-bin/nintendo-switch-coreboot-bin-9999.ebuild config"
}
