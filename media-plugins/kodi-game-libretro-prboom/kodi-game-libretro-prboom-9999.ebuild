# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="PRboom for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.prboom"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.prboom.git"
	inherit git-r3
        KEYWORDS="~amd64 ~x86 ~arm64"
else
        KEYWORDS="~amd64 ~x86 ~arm64"
	SRC_URI="https://github.com/kodi-game/game.libretro.prboom/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.prboom-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	games-emulation/prboom-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"

src_prepare() {
	echo 'find_library(PRBOOM_LIB NAMES prboom_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-prboom.cmake" || die
	cmake_src_prepare
}
