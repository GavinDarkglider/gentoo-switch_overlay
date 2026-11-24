# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="drhelius/Gearsystem"
LIBRETRO_COMMIT_SHA="2fdd8f7c8ff3ae9523dafb7f1d8125776e96aae6"
inherit libretro-core

DESCRIPTION="Gearsystem libretro port (Sega Master System / Game Gear / SG-1000)"
HOMEPAGE="https://github.com/drhelius/Gearsystem"
S="${WORKDIR}/Gearsystem-${LIBRETRO_COMMIT_SHA}/platforms/libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

DEPEND="dev-libs/miniz"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

myemakeargs=( "SYSTEM_MINIZ=1" )
