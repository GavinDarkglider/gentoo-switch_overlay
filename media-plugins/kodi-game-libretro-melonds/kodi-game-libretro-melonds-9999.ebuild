# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Melonds  GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.melonds"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.melonds.git"
	inherit git-r3
        KEYWORDS="~amd64 ~x86 ~arm64"
else
        KEYWORDS="~amd64 ~x86 ~arm64"
	SRC_URI="https://github.com/kodi-game/game.libretro.melonds/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.melonds-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	games-emulation/fceumm-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo 'find_library(MELONDS_LIB NAMES melonds_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-melonds.cmake" || die
	cmake_src_prepare
}
