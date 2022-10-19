# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://gitlab.com/switchroot/userspace/joycond"
EGIT_BRANCH="linux"

inherit cmake linux-info udev git-r3

DESCRIPTION="Daemon that uses hid-nintendo evdev devices to implement joycon pairing"
HOMEPAGE="https://gitlab.com/switchroot/userspace/joycond"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64"

DEPEND="
	dev-libs/libevdev
	virtual/udev
"

RDEPEND="
	${DEPEND}
"

CONFIG_CHECK="
	~HID
	~HID_NINTENDO
	~HIDRAW
"


PATCHES=(
	"${FILESDIR}"/${PN}-systemd-paths.patch
	"${FILESDIR}"/${PN}-systemd-paranoia.patch
	"${FILESDIR}"/Fix-cmake-install.patch
)

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
