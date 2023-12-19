# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/PokeMini"

inherit libretro-core

DESCRIPTION="Obscure nintendo handheld emulator."
HOMEPAGE="https://github.com/libretro/PokeMini"
KEYWORDS="~arm64"

LICENSE="pokemini"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
