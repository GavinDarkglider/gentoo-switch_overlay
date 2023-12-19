# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Free assembler/linker package for the Game Boy and Game Boy Color"
HOMEPAGE="https://rednex.github.io/rgbds/"
SRC_URI="https://github.com/rednex/${PN}/releases/download/v${PV}/${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="arm64"
IUSE=""

RDEPEND="
	media-libs/libpng:=
"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex
	virtual/pkgconfig
"
src_unpack() {
	default
	mv "${WORKDIR}/${PN}" "${WORKDIR}/${P}"
}

src_compile() {
	emake Q= || die
}

src_install() {
	emake Q= STRIP= DESTDIR="${D}" PREFIX=/usr mandir=/usr/share/man install || die
}
