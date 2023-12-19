# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bk-emulator"
LIBRETRO_COMMIT_SHA="07fae28627f420fc0dfcb533559df798ac4fbb81"

inherit libretro-core

DESCRIPTION="BK-0010/0011/Terak 8510a emulator for libretro"
HOMEPAGE="https://github.com/libretro/bk-emulator"
KEYWORDS="~arm64"

LICENSE="bk"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
