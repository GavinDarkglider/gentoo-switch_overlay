# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/81-libretro"
LIBRETRO_COMMIT_SHA="028da99de5a69c1d067eb3f270c0507377c83bb7"
inherit libretro-core

DESCRIPTION="A port of the EightyOne ZX81 Emulator to libretro"
HOMEPAGE="https://github.com/libretro/81-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

