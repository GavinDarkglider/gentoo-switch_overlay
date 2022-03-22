EAPI=7
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"
DESCRIPTION="initramfs for Nintendo Switch"
S="${WORKDIR}"

IUSE=""

RESTRICT="mirror"
SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/blob/master/distfiles/65NintendoSwitch-${PV}.tar.gz?raw=true -> 65NintendoSwitch-${PV}.tar.gz"

RDEPEND="
	sys-kernel/dracut
	sys-boot/reboot2hekate-bin
	app-editors/vim-core"

src_install() {
	insinto /usr/lib/dracut/modules.d/
	doins -r "${S}"/Downloads/65NintendoSwitch

	insinto /etc/dracut.conf.d/
	doins "${FILESDIR}"/NintendoSwitch.conf
}
