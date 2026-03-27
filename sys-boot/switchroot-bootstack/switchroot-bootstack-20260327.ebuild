EAPI=7
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://switchroot.org/ https://gitlab.com/l4t-community"
DESCRIPTION="Switchroot bootstack files"

inherit sdcard-mount unpacker

SRC_URI="https://gitlab.com/l4t-community/gnu-linux/switchroot-pipeline/-/jobs/artifacts/master/raw/switchroot-fedora-boot.zip?job=bootstack_full_fedora#/switchroot-fedora-boot.zip -> switchroot-fedora-boot-5.1.2.2.zip"

IUSE="+switchroot-bl33 switchroot-scr"

# u-boot-tools required to build own scr
BDEPEND="!switchroot-scr? ( dev-embedded/u-boot-tools )"

# block own bl33 for swirtchroot or force own bl33 without swirtchroot
DEPEND="switchroot-bl33? ( !sys-boot/nintendo-switch-u-boot )"
PDEPEND="!switchroot-bl33? ( sys-boot/nintendo-switch-u-boot )"

S="${WORKDIR}"

src_compile() {
	if ! use switchroot-scr; then
		einfo "mkimage -A arm -T script -O linux -d ${FILESDIR}/boot.txt-20260327 ${S}/boot.scr"
		mkimage -A arm -T script -O linux -d "${FILESDIR}"/"boot.txt-20260327" "${S}"/boot.scr
	fi
}

src_install() {
	insinto "${SDCARD_DESTDIR}"

	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	newins "${FILESDIR}"/L4T-gentoo.ini-20260327 L4T-gentoo.ini

	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins "${S}"/switchroot/fedora/bl31.bin

	use switchroot-bl33 && doins "${S}"/switchroot/fedora/bl33.bin

	if use switchroot-scr; then
		doins "${S}"/switchroot/fedora/boot.scr
	else
		doins "${S}"/boot.scr
	fi

#	dodoc "${S}"/opt/switchroot/bootstack/README_CONFIG.txt
#	doins bootlogo_gentoo.bmp
#	doins icon_gentoo_hue_bmp
}

pkg_postinst() {
	if use switchroot-scr; then
		ewarn ""
		ewarn "Switchroot provided boot.scr does not support loading files from /boot"
		ewarn "Please copy uImage, initramfs and nx-plat.dtimg"
		ewarn "to the /switchroot/gentoo in first vfat partition"
	fi
}
