# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev xdg

DESCRIPTION="Gamepad and touch first console desktop for Nintendo Switch (L4T)"
HOMEPAGE="https://gitlab.com/l4t-community/mithraui"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/l4t-community/mithraui.git"
else
	COMMIT="34c826408f4f238c9937485543fbbda85bc762f7"
	SRC_URI="https://gitlab.com/l4t-community/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2
		-> ${P}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~arm64"
fi

# the code GPL-2, the bundled Cabin font OFL-1.1
LICENSE="GPL-2 OFL-1.1"
SLOT="0"
IUSE="+sddm wayland"

# mithra-shell uses Qt's private GUI API (rebuild with every qtbase), and
# always builds its Wayland compositor (QtWayland.Compositor from QML),
# also for the X11 session: qtbase needs wayland (qtwayland requires it)
# even on an X11-only system
DEPEND="
	dev-qt/qtbase:6=[X,dbus,gui,network,wayland]
	dev-qt/qtdeclarative:6
	dev-qt/qtvirtualkeyboard:6
	dev-qt/qtwayland:6[qml]
	dev-libs/wayland
	media-libs/libsdl2
	sys-libs/pam
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libxcb:=
"
# the shell forces the breeze icon theme (SVG); audio, power, Wi-Fi and
# Bluetooth pages call pactl/paplay and talk to NetworkManager, bluez and
# upower over D-Bus; the X11 session runs openbox and xinput/xset
RDEPEND="${DEPEND}
	app-admin/sudo
	dev-qt/qtsvg:6
	kde-frameworks/breeze-icons:6
	media-libs/libpulse
	net-misc/networkmanager
	net-wireless/bluez
	sys-power/upower
	x11-apps/xinput
	x11-apps/xset
	x11-wm/openbox
	sddm? ( gui-apps/sddm )
	wayland? (
		dev-qt/qtbase:6[eglfs]
		gui-libs/egl-wayland
		x11-base/xwayland
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# loginctl for power actions, rc-service for the session switch (OpenRC)
	"${FILESDIR}"/${PN}-0.1.0_p20261101-openrc.patch
)

src_configure() {
	local mycmakeargs=(
		-DMITHRA_BUILD_TESTS=OFF
		-DMITHRA_BUILD_COMPOSITOR=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# a MithraKit development harness, not shipped (as upstream's package)
	rm "${ED}"/usr/bin/mithra-demo || die

	# udev rules belong under /usr/lib/udev
	rm -r "${ED}"/etc/udev || die
	udev_dorules session/99-zz-mithra-touch.rules

	# wheel may run the two checked helpers (nvpmodel profiles, sddm autologin)
	fperms 0440 /etc/sudoers.d/mithra

	if ! use sddm; then
		rm -r "${ED}"/usr/share/sddm || die
	fi

	if ! use wayland; then
		rm "${ED}"/usr/bin/mithra-wayland-session \
			"${ED}"/usr/libexec/mithra/libmithra-nvdc-compat.so || die
		rm -r "${ED}"/usr/share/wayland-sessions "${ED}"/usr/share/mithra \
			"${ED}"/usr/lib/modprobe.d "${ED}"/usr/lib/modules-load.d || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
	elog "Choose \"MithraUI (X11)\" at the login screen."
	use wayland && elog "The Wayland session needs the L4T BSP's EGLStream support (tegra-udrm)."
	elog "Members of wheel may switch power profiles and autologin from the shell"
	elog "(/etc/sudoers.d/mithra)."
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
