# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="FBAlpha2012 GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.fbalpha2012"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.fbalpha2012.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-game/game.libretro.fbalpha2012/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.fbalpha2012-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	games-emulation/fbalpha2012-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo 'find_library(FBALPHA2012_LIB NAMES fbalpha2012_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-fbalpha2012.cmake" || die
	default
}
