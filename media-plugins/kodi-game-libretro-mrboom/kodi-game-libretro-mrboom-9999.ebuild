# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="MRBoom GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.mrboom"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.mrboom.git"
	inherit git-r3
        KEYWORDS="~amd64 ~x86 ~arm64"
else
        KEYWORDS="~amd64 ~x86 ~arm64"
	SRC_URI="https://github.com/kodi-game/game.libretro.mrboom/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.mrboom-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	games-emulation/mrboom-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo 'find_library(MRBOOM_LIB NAMES mrboom_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-mrboom.cmake" || die
	cmake_src_prepare
}
