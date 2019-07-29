# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-2 cmake-utils

DESCRIPTION="Joycon pairing daemon to be used with hid-joycon driver"
HOMEPAGE="https://github.com/DanielOgorchock/joycond/"
EGIT_REPO_URI="git://github.com/DanielOgorchock/joycond"
EGIT_BRANCH="master"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="systemd openrc"

DISABLE_AUTOFORMATTING="yes"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	sed -i 's+/var/tmp/portage/media-libs/joycond-9999/work/joycond-9999/joycond+/var/tmp/portage/media-libs/joycond-9999/work/joycond-9999_build/joycond+g' "${WORKDIR}/joycond-9999_build/cmake_install.cmake"
	cmake-utils_src_install
}


