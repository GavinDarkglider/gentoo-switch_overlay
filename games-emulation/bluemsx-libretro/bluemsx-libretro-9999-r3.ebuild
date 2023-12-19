# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/blueMSX-libretro"
inherit libretro-core

DESCRIPTION="Port of blueMSX to the libretro API"
HOMEPAGE="https://github.com/libretro/blueMSX-libretro"
KEYWORDS="~arm64"

LICENSE="bluemsx"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
