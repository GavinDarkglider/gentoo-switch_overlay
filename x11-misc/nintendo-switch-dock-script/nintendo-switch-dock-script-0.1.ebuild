# Copyright 2019 bell07
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Nintendo Switch dock handler script"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="!app-eselect/eselect-nintendo-switch-dock-handler"

S="${WORKDIR}"

src_install() {
	dobin "${FILESDIR}"/dock-script.sh

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/93-dock-script.rules

	insinto /etc
	doins "${FILESDIR}"/dock-script.env
}
