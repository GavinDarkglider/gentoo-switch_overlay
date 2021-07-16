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

src_prepare() {
	einfo "Patch files to gentoo specific settings"
	cat >> "${S}"/switchroot/gentoo/uenv.txt << EOF

# Read kernel files from /boot of partition 2
distro_bootpart=2
boot_dir=/boot

# Enable and rotate device framebuffer
hdmi_fbconsole=0
bootargs_extra=fbcon=rotate:3
EOF
	eapply_user
}

src_install() {
	insinto "${SDCARD_DESTDIR}"
	doins -r "${S}"/bootloader
	doins -r "${S}"/switchroot
}
