EAPI=6
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"
DESCRIPTION="Updater Scripts for Nintendo Switch boot chain"
S="${WORKDIR}"

COREBOOT_FILE="coreboot-GavinDarkglider-20190817.rom"
DTB_FILE="tegra210-icosa.dtb-GavinDarkglider-20190817.rom"

RESTRICT="mirror"
SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/crosscompiled/${COREBOOT_FILE}?raw=true -> ${COREBOOT_FILE}
         https://github.com/bell07/bashscripts-switch_gentoo/blob/master/crosscompiled/${DTB_FILE}?raw=true -> ${DTB_FILE}"

DEPEND="sys-boot/cbfstool"
RDEPEND="sys-boot/nintendo-switch-u-boot"

src_unpack() {
	mkdir -p "${S}"
	cp -v "${DISTDIR}/${COREBOOT_FILE}" "${S}"/coreboot.rom
	cp -v "${DISTDIR}/${DTB_FILE}" "${S}"/tegra210-icosa.dtb
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
	doins tegra210-icosa.dtb

	insinto /etc
	doins "${FILESDIR}/nintendo-switch-boot.txt"

	dobin "${FILESDIR}"/update-coreboot.sh
	dobin "${FILESDIR}"/update-boot.scr.sh
}
