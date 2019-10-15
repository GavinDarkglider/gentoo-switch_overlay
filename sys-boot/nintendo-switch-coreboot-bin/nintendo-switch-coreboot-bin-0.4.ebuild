EAPI=6
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"
DESCRIPTION="Updater Scripts for Nintendo Switch boot chain"
S="${WORKDIR}"

COREBOOT_FILE="coreboot-GavinDarkglider-20191015.rom"

RESTRICT="mirror"
SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/crosscompiled/${COREBOOT_FILE}?raw=true -> ${COREBOOT_FILE}"

DEPEND="sys-boot/cbfstool
		sys-boot/nintendo-switch-u-boot"

src_unpack() {
	mkdir -p "${S}"
	cp -v "${DISTDIR}/${COREBOOT_FILE}" "${S}"/coreboot.rom
}
src_compile() {
		einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
		einfo "   update-coreboot.sh coreboot.bin "${ROOT}"/usr/share/u-boot/u-boot.elf"
		sh "${FILESDIR}"/update-coreboot.sh coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
}

src_install() {
	dodir /boot
	insinto /boot
	doins coreboot.rom

	insinto /etc
	doins "${FILESDIR}/nintendo-switch-boot.txt"

	dobin "${FILESDIR}"/update-coreboot.sh
	dobin "${FILESDIR}"/update-boot.scr.sh
}
