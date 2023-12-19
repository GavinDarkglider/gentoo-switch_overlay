# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bk-emulator"
LIBRETRO_COMMIT_SHA="70f4a2d812379b8e3e3c7ed3025d08583dee98b1"

inherit libretro-core

DESCRIPTION="BK-0010/0011/Terak 8510a emulator for libretro"
HOMEPAGE="https://github.com/libretro/bk-emulator"
KEYWORDS="~arm64"

LICENSE="bk"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
