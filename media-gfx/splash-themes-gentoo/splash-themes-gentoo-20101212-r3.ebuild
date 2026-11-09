# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Gentoo's mirrors dropped these long ago; ChromeOS's mirror of Gentoo's
# distfiles still has the originals (checked against the 2012 Manifest).
CROS_MIRROR="https://commondatastorage.googleapis.com/chromeos-mirror/gentoo/distfiles"

DESCRIPTION="The classic Gentoo fbsplash themes: emergence, gentoo, emerge-world"
HOMEPAGE="https://wiki.gentoo.org/wiki/Fbsplash"
SRC_URI="
	${CROS_MIRROR}/fbsplash-theme-emergence-r2.tar.bz2
	${CROS_MIRROR}/fbsplash-theme-gentoo-r2.tar.bz2
	${CROS_MIRROR}/fbsplash-theme-emerge-world-1.0.tar.bz2
"
S="${WORKDIR}"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="binchecks strip"

RDEPEND="media-gfx/splashutils[png(+)]"

src_install() {
	insinto /etc/splash
	doins -r emergence gentoo emerge-world

	# Theme hook scripts (bug #470100)
	if [[ -d emerge-world/scripts ]]; then
		fperms 755 /etc/splash/emerge-world/scripts/{svc_started,svc_start,svc_stopped,svc_stop}-pre
	fi
}

pkg_postinst() {
	elog "Natural Gentoo used to be part of this package; it is now"
	elog "media-gfx/fbsplash-theme-natural-gentoo."
}
