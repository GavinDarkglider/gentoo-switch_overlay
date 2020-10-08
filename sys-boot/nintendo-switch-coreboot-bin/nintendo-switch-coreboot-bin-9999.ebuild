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
	einfo "   update-coreboot.sh coreboot.bin "${ROOT}"/usr/share/u-boot/u-boot.elf"
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
