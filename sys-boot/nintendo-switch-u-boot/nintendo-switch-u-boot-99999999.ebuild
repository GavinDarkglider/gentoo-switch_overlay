EAPI="6"
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/switch-uboot"
DESCRIPTION='"Das U-Boot" Source Tree for the Switch'

inherit git-r3

EGIT_REPO_URI="https://gitlab.com/switchroot/switch-uboot"
EGIT_BRANCH="linux-norebase"
EGIT_CHECKOUT_DIR="${S}"


DEPEND="dev-lang/swig
	sys-apps/dtc"

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
	einfo "Update the coreboot.rom and boot.scr using "
	einfo "   ebuild /var/db/repos/switch_overlay/sys-boot/l4s-bootstack/l4s-bootstack-9999.ebuild config"
	einfo " or by sys-boot/l4s-bootstack rebuild"
}
