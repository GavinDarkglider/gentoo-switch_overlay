EAPI=7
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/bootstack/bootstack-build-scripts"
DESCRIPTION="Linux-4-Switch bootstack files"

inherit sdcard-mount

SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/distfiles/switchroot-gentoo-boot-${PV//[.]/-}.7z?raw=true -> switchroot-gentoo-boot-${PV//[.]/-}.7z"

DEPEND="!sys-boot/l4s-bootstack
	app-arch/p7zip"

S="${WORKDIR}"

src_install() {
	insinto "${SDCARD_DESTDIR}"
	doins -r "${S}"/bootloader
	doins -r "${S}"/switchroot
}
