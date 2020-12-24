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
	sed -i 's/L4T-bionic.ini/L4T-gentoo.ini/g' "${S}"/linux_boot.txt
	sed -i 's/runlevel=2/runlevel=3/g' "${S}"/build.sh
	eapply_user
}

src_compile() {
	einfo "mkimage -A arm -T script -O linux -d ${S}/linux_boot.txt ${S}/boot.scr"
	mkimage -A arm -T script -O linux -d "${S}"/linux_boot.txt "${S}"/boot.scr

	einfo "extract ini file creation from build.sh and create L4T-gentoo.ini"
	fgrep -A 9999 'Create hekate_ini in bootloader directory' build.sh > build-ini.sh
	mkdir -p bootloader/ini
	out=. DISTRO=gentoo sh build-ini.sh
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins boot.scr

	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	doins bootloader/ini/L4T-gentoo.ini
}
