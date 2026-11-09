# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Gentoo's mirrors dropped these long ago; ChromeOS's mirror of Gentoo's
# distfiles still has the originals (checked against the 2012 Manifest).
CROS_MIRROR="https://commondatastorage.googleapis.com/chromeos-mirror/gentoo/distfiles"

DESCRIPTION="fbsplash themes of the Gentoo LiveCD releases 2004.3 to 2007.0"
HOMEPAGE="https://wiki.gentoo.org/wiki/Fbsplash"
SRC_URI="
	${CROS_MIRROR}/splash-themes-livecd-2004.3.tar.bz2
	${CROS_MIRROR}/gentoo-livecd-2005.0-0.9.1.tar.bz2
	${CROS_MIRROR}/gentoo-livecd-2005.1-0.9.2.tar.bz2
	${CROS_MIRROR}/gentoo-livecd-2006.0-0.9.3.tar.bz2
	${CROS_MIRROR}/gentoo-livecd-2006.1-0.9.4.tar.bz2
	${CROS_MIRROR}/gentoo-livecd-2007.0-0.9.6.tar.bz2
"
S="${WORKDIR}"

LICENSE="Artistic GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="binchecks strip"

RDEPEND="media-gfx/splashutils[png(+)]"

src_install() {
	local v
	insinto /etc/splash
	doins -r livecd-2004.3
	# installed as livecd-<release>, like Gentoo's ebuilds did
	for v in 2005.0 2005.1 2006.0 2006.1 2007.0; do
		mv gentoo-livecd-${v} livecd-${v} || die
		doins -r livecd-${v}
	done
}
