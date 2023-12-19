# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/PokeMini"
LIBRETRO_COMMIT_SHA="40092c4ea1f15fce877c0b942c4fe907b5f3b6ff"

inherit libretro-core

DESCRIPTION="Obscure nintendo handheld emulator."
HOMEPAGE="https://github.com/libretro/PokeMini"
KEYWORDS="~arm64"

LICENSE="pokemini"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
