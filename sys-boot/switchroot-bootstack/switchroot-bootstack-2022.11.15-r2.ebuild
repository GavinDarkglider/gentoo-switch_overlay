EAPI=7
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/bootstack/bootstack-build-scripts"
DESCRIPTION="Linux-4-Switch bootstack files"

inherit sdcard-mount

SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/distfiles/switchroot-gentoo-boot-${PV//[.]/-}.7z?raw=true -> switchroot-gentoo-boot-${PV//[.]/-}.7z"

DEPEND="dev-embedded/u-boot-tools
	app-arch/p7zip"

S="${WORKDIR}"

src_compile() {
	einfo "mkimage -A arm -T script -O linux -d ${FILESDIR}/boot.txt ${S}/boot.scr"
	mkimage -A arm -T script -O linux -d "${FILESDIR}"/boot.txt "${S}"/boot.scr
}

src_install() {
	insinto "${SDCARD_DESTDIR}"
	doins -r "${S}"/bootloader

	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins "${S}"/switchroot/gentoo/coreboot.rom
	doins "${S}"/switchroot/gentoo/bootlogo_gentoo.bmp
	doins "${S}"/boot.scr
	doins "${FILESDIR}"/uenv.txt
}
