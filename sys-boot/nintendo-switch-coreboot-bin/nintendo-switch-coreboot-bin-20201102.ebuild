EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"
DESCRIPTION="Updater Scripts for Nintendo Switch boot chain"
S="${WORKDIR}"

IUSE="uboot_update"

COREBOOT_FILE="coreboot-${PV}.rom"

RESTRICT="mirror"
SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/distfiles/${COREBOOT_FILE}?raw=true -> ${COREBOOT_FILE}"

DEPEND="uboot_update? (
	sys-boot/cbfstool
	sys-boot/nintendo-switch-u-boot )
	!sys-boot/nintendo-switch-coreboot"

inherit sdcard-mount

src_unpack() {
	mkdir -p "${S}"
	cp -v "${DISTDIR}/${COREBOOT_FILE}" "${S}"/coreboot.rom
}

src_compile() {
	if use uboot_update; then
		einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
		einfo "   update-coreboot.sh coreboot.bin "${ROOT}"/usr/share/u-boot/u-boot.elf"
		sh "${FILESDIR}"/update-coreboot.sh coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
	fi
}

src_install() {
	dobin "${FILESDIR}"/update-coreboot.sh

	dodir "${SDCARD_DESTDIR}"/switchroot/gentoo
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins coreboot.rom
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
