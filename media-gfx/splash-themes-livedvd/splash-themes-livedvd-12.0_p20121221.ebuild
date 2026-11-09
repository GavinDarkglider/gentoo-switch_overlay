# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The original splash-themes-livedvd-12.0.tar.bz2 is lost (not on any
# mirror, not in the Internet Archive).  This tarball is the theme as it
# was installed on the Gentoo 20121221 live DVD (livedvd-amd64-multilib-
# 20121221.iso, /etc/splash/livecd-12.0 in image.squashfs), repacked.

DESCRIPTION="fbsplash theme of the Gentoo 12.0 live DVD"
HOMEPAGE="https://wiki.gentoo.org/wiki/Fbsplash"
SRC_URI="${P}.tar.bz2"
S="${WORKDIR}/livecd-12.0"

LICENSE="Artistic GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="binchecks fetch strip"

RDEPEND="media-gfx/splashutils[png(+),truetype(+)]"

pkg_nofetch() {
	einfo "Put ${A} (recovered from the 20121221 live DVD) in"
	einfo "your DISTDIR: ${DISTDIR}"
}

src_prepare() {
	default
	# splash_util.static is only there when splashutils is built without
	# MNG; plain splash_util always is
	sed -i -e 's:/sbin/splash_util\.static:/sbin/splash_util:' \
		scripts/rc_init-pre || die
}

src_install() {
	insinto /etc/splash/livedvd-${PV%_p*}
	doins -r .
	fperms 755 /etc/splash/livedvd-${PV%_p*}/scripts/{rc_init-pre,rc_exit-post}
	# the DVD called it livecd-12.0 (splash=silent,theme:livecd-12.0)
	dosym livedvd-${PV%_p*} /etc/splash/livecd-${PV%_p*}
}
