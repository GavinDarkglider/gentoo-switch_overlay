EAPI=8
KEYWORDS="arm64"
SLOT="0"
IUSE="live"

HOMEPAGE="https://switchroot.org/ https://gitlab.com/switchroot/bootstack"
DESCRIPTION="Switchroot bootstack files, all made from source"

inherit git-r3 sdcard-mount

# only the Gentoo icons come from here (the raw file links refuse
# downloads by programs; git doesn't)
EGIT_REPO_URI="https://gitlab.com/switchroot/bootstack/bootstack-build-scripts.git"
EGIT_COMMIT="84512cc0b5d80755de896209712c422af5325831"

# mkimage makes boot.scr from boot.txt
BDEPEND="dev-embedded/u-boot-tools"
# bl31.bin (Trusted Firmware-A) and bl33.bin (U-Boot) are built by
# their own packages, into the same folder
RDEPEND="
	sys-boot/switch-atf
	sys-boot/nintendo-switch-u-boot
"

src_compile() {
	mkimage -A arm -T script -O linux -d "${FILESDIR}"/boot.txt-20261125 "${S}"/boot.scr \
		|| die "mkimage failed"
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	newins "${FILESDIR}"/L4T-gentoo.ini-20260327 L4T-gentoo.ini

	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins "${S}"/boot.scr
	doins "${S}"/assets/Hekate-Icons/gentoo/icon_gentoo.bmp
	doins "${S}"/assets/Hekate-Icons/gentoo/icon_gentoo_hue.bmp

	if use live; then
		# the installer: the same boot.scr, live=1 in its ini. Its packaging
		# puts the kernel (initramfs built in), nx-plat.dtimg and
		# rootfs.squashfs into the same folder
		insinto "${SDCARD_DESTDIR}"/bootloader/ini
		newins "${FILESDIR}"/L4T-gentoo-installer.ini-20261125 L4T-gentoo-installer.ini
		insinto "${SDCARD_DESTDIR}"/switchroot/gentoo-installer
		doins "${S}"/boot.scr
	fi
}
