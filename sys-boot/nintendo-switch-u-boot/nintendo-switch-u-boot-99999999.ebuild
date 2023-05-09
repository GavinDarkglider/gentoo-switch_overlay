EAPI="6"
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/switch-uboot"
DESCRIPTION='"Das U-Boot" Source Tree for the Switch'

inherit git-r3
inherit sdcard-mount

EGIT_REPO_URI="https://gitlab.com/switchroot/switch-uboot"
EGIT_BRANCH="linux-hekatf"
EGIT_CHECKOUT_DIR="${S}"


DEPEND="dev-lang/swig"

PATCHES=(
    "${FILESDIR}"/gcc-10-fix.patch
    "${FILESDIR}"/dtb-build.patch
)

src_configure() {
    einfo "Use provided nintendo-switch_defconfig"
    emake nintendo-switch_defconfig
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	newins u-boot-dtb.bin bl33.bin
}
