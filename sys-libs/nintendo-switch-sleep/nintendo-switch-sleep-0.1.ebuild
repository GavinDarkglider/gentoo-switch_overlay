# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Nintendo Switch lp0 sleep fixes script"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="sys-auth/elogind"

S="${WORKDIR}"

src_install() {
	exeinto /lib64/elogind/system-sleep/
	doexe "${FILESDIR}"/nintendo-fixes.sh
}
