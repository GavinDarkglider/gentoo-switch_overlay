# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="Joycon pairing daemon to be used with hid-joycon driver"
HOMEPAGE="https://github.com/DanielOgorchock/joycond/"
EGIT_REPO_URI="git://github.com/DanielOgorchock/joycond"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="systemd"

DISABLE_AUTOFORMATTING="yes"

src_compile() {
	cmake-utils_src_compile
	sed -i 's+/var/tmp/portage/media-libs/joycond-9999/work/joycond-9999/joycond+/var/tmp/portage/media-libs/joycond-9999/work/joycond-9999_build/joycond+g' "${WORKDIR}/joycond-9999_build/cmake_install.cmake"
}

src_install() {
	cmake-utils_src_install
	if ! use systemd ; then
		rm -Rf "${D}"/etc/systemd
		exeinto /etc/init.d
		doexe "${FILESDIR}"/joycond
	fi
}
