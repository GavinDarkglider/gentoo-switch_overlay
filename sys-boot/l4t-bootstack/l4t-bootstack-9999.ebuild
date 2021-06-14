EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/bootstack/bootstack-build-scripts"
DESCRIPTION="Linux-4-Switch bootstack files"

inherit git-r3 sdcard-mount

EGIT_REPO_URI="https://gitlab.com/switchroot/bootstack/bootstack-build-scripts"
EGIT_BRANCH="master"
EGIT_SUBMODULES=()

DEPEND="dev-embedded/u-boot-tools
	!sys-boot/l4s-bootstack"


src_prepare() {
	einfo "Patch files to gentoo specific settings"
	sed -i 's/^setenv distro .*$/setenv distro gentoo/g' "${S}"/assets/boot.txt
	sed -i 's/runlevel=2/runlevel=3/g' "${S}"/assets/uenv.txt
	eapply_user
}

src_compile() {
	einfo "mkimage -A arm -T script -O linux -d ${S}/assets/boot.txt ${S}/boot.scr"
	mkimage -A arm -T script -O linux -d "${S}"/assets/boot.txt "${S}"/boot.scr
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins "${S}"/boot.scr
	doins "${S}"/assets/uenv.txt
	doins "${S}"/assets/Hekate-Icons/gentoo/icon_gentoo_hue.bmp
	doins "${S}"/assets/Hekate-Icons/gentoo/icon_gentoo.bmp

	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	doins "${FILESDIR}"/L4T-gentoo.ini
}
