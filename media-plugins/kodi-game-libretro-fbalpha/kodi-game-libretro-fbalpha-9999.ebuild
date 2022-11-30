# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="FBAlpha GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.fbalpha"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.fbalpha.git"
	inherit git-r3
        KEYWORDS="~amd64 ~x86 ~arm64"
else
        KEYWORDS="~amd64 ~x86 ~arm64"
	SRC_URI="https://github.com/kodi-game/game.libretro.fbalpha/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.fbalpha-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	games-emulation/fbalpha-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo ${S}
	sed -i 's/find_library(FBNEO_LIB NAMES fbneo_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)/find_library(FBNEO_LIB NAMES fbalpha_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)/g' ${S}/CMakeLists.txt || die
	cmake_src_prepare
}
