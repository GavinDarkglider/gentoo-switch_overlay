# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Gentoo dropped this in 2018 and its original home (dev.gentoo.org/~tampakrap)
# is gone; ChromeOS's mirror of Gentoo's distfiles still has the original
# tarball (checked against the 2012 Manifest).
CROS_MIRROR="https://commondatastorage.googleapis.com/chromeos-mirror/gentoo/distfiles"

DESCRIPTION="fbsplash theme of the Gentoo 12.0 live DVD"
HOMEPAGE="https://wiki.gentoo.org/wiki/Fbsplash"
SRC_URI="${CROS_MIRROR}/${P}.tar.bz2"

LICENSE="Artistic GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="binchecks strip"

RDEPEND="media-gfx/splashutils[png(+),truetype(+)]"

src_prepare() {
	default
	# splash_util.static is only there when splashutils is built without
	# MNG; plain splash_util always is
	sed -i -e 's:/sbin/splash_util\.static:/sbin/splash_util:' \
		scripts/rc_init-pre || die
}

src_install() {
	insinto /etc/splash/livedvd-${PV}
	doins -r .
	# the icon scripts must be executable (bug #407447)
	fperms 755 /etc/splash/livedvd-${PV}/scripts/{rc_init-pre,rc_exit-post}
	# the DVD itself called it livecd-12.0 (splash=silent,theme:livecd-12.0)
	dosym livedvd-${PV} /etc/splash/livecd-${PV}
}
