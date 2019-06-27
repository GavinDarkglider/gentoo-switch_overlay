# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="4do GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.4do"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.4do.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-game/game.libretro.4do/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.4do-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	games-emulation/4do-libretro
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo 'find_library(4DO_LIB NAMES 4do_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-4do.cmake" || die
	default
}
