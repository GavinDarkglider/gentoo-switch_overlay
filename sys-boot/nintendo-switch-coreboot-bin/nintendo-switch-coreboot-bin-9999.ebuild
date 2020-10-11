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

src_prepare() {
	sed -i 's/ubuntu/gentoo/g' "${S}"/src/uboot-scripts/linux_boot.txt
	sed -i 's/SWR-UBU/SWR-GEN/g' "${S}"/src/uboot-scripts/linux_boot.txt
	sed -i 's/SWR-UBU/SWR-GEN/g' "${S}"/src/uboot-scripts/uenv.txt
	eapply_user
}

src_compile() {
	einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
	einfo "   ${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
	sh "${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf || die "patching coreboot failed"

	echo "mkimage -A arm -T script -O linux -d ${S}/src/uboot-scripts/linux_boot.txt ${S}/boot.scr"
	mkimage -A arm -T script -O linux -d "${S}"/src/uboot-scripts/linux_boot.txt "${S}"/boot.scr
}

src_install() {
	dobin "${FILESDIR}"/update-coreboot.sh

	dodir "${SDCARD_DESTDIR}"/switchroot/gentoo
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo

	doins boot.scr
	cd src
	doins coreboot.rom
	cd uboot-scripts
	doins uenv.txt
	doins uenv_readme.txt
	doins -r overlays
}

pkg_config() {
	if [ -f /usr/share/u-boot/u-boot.elf ]; then
		einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
		einfo "${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
		"${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf  || die "patching coreboot failed"
	else
		ewarn "No u-boot.elf file found, skip updating coreboot"
	fi

	sdcard-mount_pkg_setup

	if [[ -n "${SDCARD_MOUNT_POINT}" ]] ; then
		cp -va "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${SDCARD_MOUNT_POINT}"/switchroot/gentoo || die "Pls. check if right medium mounted"
	fi
}

pkg_postinst() {
	einfo "Update the u-boot in coreboot.rom using "
	einfo "   ebuild /var/db/repos/switch_overlay/sys-boot/nintendo-switch-coreboot-bin/nintendo-switch-coreboot-bin-9999.ebuild config"
}
