EAPI="6"
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://github.com/lakka-switch/u-boot"
DESCRIPTION='"Das U-Boot" Source Tree for the Switch'

inherit git-r3

EGIT_REPO_URI="https://github.com/lakka-switch/u-boot"
EGIT_BRANCH="switch"
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
	exeinto "/usr/share/u-boot"
	doexe u-boot.elf
}

pkg_postinst() {
	elog "u-boot.elf installedd to /usr/share/u-boot/u-boot.elf"
	elog "Please update the coreboot image using update-coreboot.sh"
	elog "or reinstall sys-boot/nintendo-switch-coreboot-bin"
}
