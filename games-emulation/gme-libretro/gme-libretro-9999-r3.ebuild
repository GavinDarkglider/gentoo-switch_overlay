# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-gme"
inherit libretro-core

DESCRIPTION="Port of blargg's Game_Music_Emu library."
HOMEPAGE="https://github.com/libretro/libretro-gme"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
