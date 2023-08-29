EAPI=7
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://switchroot.org/"
DESCRIPTION="Ubuntu switchroot bootstack files"

inherit sdcard-mount unpacker

SRC_URI="https://newrepo.switchroot.org/pool/unstable/s/switch-bsp/switch-bsp_5.1.2-1_all.deb"

IUSE="ubuntu-bl33 ubuntu-scr"

# u-boot-tools required to build own scr
BDEPEND="!ubuntu-scr? ( dev-embedded/u-boot-tools )"

# block own bl33 for ubuntu or force own bl33 without ubuntu
DEPEND="ubuntu-bl33? ( !sys-boot/nintendo-switch-u-boot )"
PDEPEND="!ubuntu-bl33? ( sys-boot/nintendo-switch-u-boot )"

S="${WORKDIR}"

src_compile() {
	if ! use ubuntu-scr; then
		einfo "mkimage -A arm -T script -O linux -d ${FILESDIR}/5.1.2-boot.txt ${S}/boot.scr"
		mkimage -A arm -T script -O linux -d "${FILESDIR}"/"5.1.2-boot.txt" "${S}"/boot.scr
	fi
}

src_install() {
	insinto "${SDCARD_DESTDIR}"

	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	newins "${FILESDIR}"/5.1.0-L4T-gentoo.ini L4T-gentoo.ini

	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins "${S}"/opt/switchroot/bootstack/bl31.bin

	use ubuntu-bl33 && doins "${S}"/opt/switchroot/bootstack/bl33.bin

	if use ubuntu-scr; then
		doins "${S}"/opt/switchroot/bootstack/boot.scr
	else
		doins "${S}"/boot.scr
	fi

	dodoc "${S}"/opt/switchroot/bootstack/README_CONFIG.txt

#	doins bootlogo_gentoo.bmp
#	doins icon_gentoo_hue_bmp
}

pkg_postinst() {
	if use ubuntu-scr; then
		ewarn ""
		ewarn "Ubuntu provided boot.scr does not support loading files from /boot"
		ewarn "Please copy uImage, initramfs and nx-plat.dtimg"
		ewarn "to the /switchroot/gentoo in first vfat partition"
	fi
}
