EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://github.com/CTCaer/hekate"
DESCRIPTION="Install hekate as reboot2payload"

IUSE="nyx"

NYX_VER="0.9.6"

RESTRICT="mirror strip"
SRC_URI="https://github.com/CTCaer/hekate/releases/download/v${PV}/hekate_ctcaer_${PV}_Nyx_${NYX_VER}.zip"
S="${WORKDIR}"

DEPEND="app-arch/unzip"

inherit sdcard-mount

src_install() {
	insinto /lib/firmware
	newins hekate_ctcaer_${PV}.bin reboot_payload.bin

	if use nyx; then
		insinto "${SDCARD_DESTDIR}"
		doins -r bootloader
	fi

	exeinto /etc/init.d
	doexe "${FILESDIR}"/reboot2hekate
}

pkg_postinst() {
	einfo "Reboot parameters can be changed by kernel command line. Default values are"
	einfo "     pmc_reboot2payload.reboot_action=bootloader pmc_reboot2payload.default_payload=reboot_payload.bin pmc_reboot2payload.hekate_config_id=GENTOO"
	einfo ""
	einfo "Add the reboot2hekate service to boot runlevel to enable the reboot2hekate"
	einfo "     rc-update add reboot2hekate boot"
}
