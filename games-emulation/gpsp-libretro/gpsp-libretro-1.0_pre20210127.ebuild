# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/gpsp"
LIBRETRO_COMMIT_SHA="f70d8534a1da41376dd96edffe87cbb04cccd683"
inherit libretro-core

DESCRIPTION="Gameboy gpSP for libretro."
HOMEPAGE="https://github.com/libretro/gpsp"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
