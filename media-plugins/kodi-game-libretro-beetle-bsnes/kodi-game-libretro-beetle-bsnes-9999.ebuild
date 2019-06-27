# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="beetle-bsnes for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.beetle-bsnes"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.beetle-bsnes.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-game/game.libretro.beetle-bsnes/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.bsnes-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	games-emulation/bsnes-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"

src_prepare() {
	echo 'find_library(BEETLE-BSNES_LIB NAMES bsnes_balanced_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-bsnes.cmake" || die
	default
}
