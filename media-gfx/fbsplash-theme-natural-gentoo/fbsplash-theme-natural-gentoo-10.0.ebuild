# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=natural-gentoo

DESCRIPTION="Natural Gentoo fbsplash theme (21 resolutions)"
HOMEPAGE="https://jtyr.github.io/natural-gentoo/ https://github.com/jtyr/natural-gentoo"
SRC_URI="https://github.com/jtyr/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="media-gfx/splashutils[png(+),truetype(+)]"

src_install() {
	# The configs use absolute /etc/splash/natural-gentoo paths.
	insinto /etc/splash
	doins -r etc/splash/${MY_PN}

	# The theme used to be called natural_gentoo in Gentoo.
	dosym ${MY_PN} /etc/splash/natural_gentoo

	dodoc README
}

pkg_postinst() {
	elog "Use it with splash=silent,theme:${MY_PN} on the kernel command line."
	elog "The GRUB background shipped in the upstream tarball is not installed."
}
