EAPI="6"
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/switch-uboot/"
DESCRIPTION='"Das U-Boot" Source Tree for the Switch'

inherit git-r3

EGIT_REPO_URI="https://gitlab.com/switchroot/switch-uboot/"
EGIT_BRANCH="android"
EGIT_CHECKOUT_DIR="${S}"


DEPEND="dev-lang/swig"

PATCHES=(
    "${FILESDIR}/gentoo_path.patch"
)

src_configure() {
    einfo "Use provided nintendo-switch_defconfig"
    cp "${S}"/configs/nintendo-switch_defconfig  "${S}"/.config || die "copy failed"

    einfo "Apply olddefconfig"
    cd "${S}"
    emake olddefconfig 2>/dev/null || die "emake olddefconfig failed"
}

src_install() {
	exeinto "/boot"
	doexe u-boot.elf
}

pkg_postinst() {
	elog "u-boot.elf is not used automagically, just copied to /boot"
	elog "Please update the coreboot image using this payload"
}
