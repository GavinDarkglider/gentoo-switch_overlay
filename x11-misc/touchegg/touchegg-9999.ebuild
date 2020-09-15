# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 qmake-utils

DESCRIPTION="Linux multitouch gesture recognizer"
HOMEPAGE="https://github.com/JoseExposito/touchegg"

EGIT_REPO_URI="git://github.com/manashmandal/touchegg.git https://github.com/manashmandal/touchegg.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
    dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	x11-libs/libXtst
	x11-libs/geis
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake4 ${PN}.pro
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs
}
