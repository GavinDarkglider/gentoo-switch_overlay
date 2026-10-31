# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Multi-touch gesture recognizer for X11 (libinput based)"
HOMEPAGE="https://github.com/JoseExposito/touchegg"
SRC_URI="https://github.com/JoseExposito/touchegg/archive/refs/tags/2.0.18.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gtk"

DEPEND="
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/pugixml:=
	virtual/libudev:=
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXtst
	gtk? ( x11-libs/gtk+:3[X] )
"
RDEPEND="
	${DEPEND}
	acct-group/input
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# upstream master after 2.0.18: CMake 4 minimum version, libinput_interface init
	"${FILESDIR}"/${P}-cmake4-libinput-iface.patch
)

src_configure() {
	local mycmakeargs=(
		# unit is installed by the ebuild, so don't require systemd.pc
		-DUSE_SYSTEMD=OFF
		-DAUTO_COLORS=$(usex gtk)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	sed -e "s|@CMAKE_INSTALL_FULL_BINDIR@|${EPREFIX}/usr/bin|" \
		installation/touchegg.service.in > "${T}"/touchegg.service || die
	systemd_dounit "${T}"/touchegg.service

	newinitd "${FILESDIR}"/touchegg.initd touchegg

	einstalldocs
}

pkg_postinst() {
	elog "Touchegg runs as two parts:"
	elog "  * a root daemon that reads libinput:"
	elog "      OpenRC:  rc-update add touchegg default && rc-service touchegg start"
	elog "      systemd: systemctl enable --now touchegg.service"
	elog "  * a per-session client, started via /etc/xdg/autostart/touchegg.desktop"
	elog "    (LXDE honours XDG autostart)."
	elog
	elog "Gesture config: copy ${EROOT}/usr/share/touchegg/touchegg.conf to"
	elog "~/.config/touchegg/touchegg.conf and edit it there."
	if ! use gtk; then
		elog
		elog "Built with USE=-gtk: color=\"auto\" in touchegg.conf falls back to defaults."
	fi
}
