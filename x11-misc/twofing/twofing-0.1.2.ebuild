# Copyright 2015 Mads; 2019 bell07
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="twofing is a daemon which runs in the background and recognizes two-finger gestures performed on a touchscreen and converts them into mouse and keyboard events."
HOMEPAGE="http://plippo.de/p/twofing"

BASE_URI="http://plippo.de/dwl/twofing"
SRC_URI="${BASE_URI}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"
RESTRICT="mirror"

DEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXi
	x11-libs/libXrandr
	x11-base/xorg-proto"

src_install() {
	dobin "${PN}"
	insinto /usr/share/X11/xorg.conf.d
	doins "${FILESDIR}"/41-evdev-touchscreen.conf

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/89-touchscreen-twofing.rules

	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/twofing.desktop
}
