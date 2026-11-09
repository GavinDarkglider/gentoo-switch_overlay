# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Gentoo's mirrors dropped these long ago; the Internet Archive kept the
# 2012 copies (checked against the 2012 Manifest).  emerge-world-1.0 and
# natural_gentoo-9.0-r2 weren't archived; Natural Gentoo is now
# media-gfx/fbsplash-theme-natural-gentoo.
WAYBACK="https://web.archive.org/web/2012id_/http://distfiles.gentoo.org/distfiles"

DESCRIPTION="The classic Gentoo fbsplash themes: emergence and gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Fbsplash"
SRC_URI="
	${WAYBACK}/fbsplash-theme-emergence-r2.tar.bz2
	${WAYBACK}/fbsplash-theme-gentoo-r2.tar.bz2
"
S="${WORKDIR}"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="binchecks strip"

RDEPEND="media-gfx/splashutils[png(+)]"

src_install() {
	insinto /etc/splash
	doins -r emergence gentoo
}

pkg_postinst() {
	elog "Natural Gentoo used to be part of this package; it is now"
	elog "media-gfx/fbsplash-theme-natural-gentoo."
}
