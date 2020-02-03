EAPI=6
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://github.com/CTCaer/hekate https://gitlab.com/bell07/gentoo-switch_overlay"
DESCRIPTION="Install hekate as reboot2payload"

NYX_VER="0.8.4"

RESTRICT="mirror strip"
SRC_URI="https://github.com/CTCaer/hekate/releases/download/v${PV}/hekate_ctcaer_${PV}_Nyx_${NYX_VER}.zip"
S="${WORKDIR}"

src_install() {
	insinto /lib/firmware
	newins hekate_ctcaer_${PV}.bin reboot_payload.bin

	insinto /usr/share/sdcard1
	doins -r bootloader

	insinto /usr/share/sdcard1/bootloader/ini
	doins "${FILESDIR}"/Gentoo.ini

	exeinto /etc/init.d
	doexe "${FILESDIR}"/reboot2hekate
}

pkg_postinst() {
	einfo "Reboot parametrs can be changed by kernel command line. Default values are"
	einfo "     pmc_reboot2payload.reboot_action=bootloader pmc_reboot2payload.default_payload=reboot_payload.bin pmc_reboot2payload.hekate_config_id=GENTOO"
	einfo ""
	einfo "Add the reboot2hekate service to boot runlevel to enable the reboot2hekate"
	einfo "     rc-update add reboot2hekate boot"
	einfo ""
	einfo "It is recommended to copy the hekate's bootloader folder to the first vfat partition"
	einfo "installed into /usr/share/sdcard1/bootloader, to get full hekate functionality"
	einfo "i.e. the nice NYX gui"
}
