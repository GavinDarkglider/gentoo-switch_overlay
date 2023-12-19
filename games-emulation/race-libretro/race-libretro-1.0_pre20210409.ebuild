# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/RACE"
LIBRETRO_COMMIT_SHA="8402277aad01e6dedf7c636e9ba17fffc7beef96"

inherit libretro-core

DESCRIPTION="Modified ngpc emulator to run on psp, ported to libretro"
HOMEPAGE="https://github.com/libretro/RACE"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
