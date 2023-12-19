# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vemulator-libretro"
LIBRETRO_COMMIT_SHA="d7f48a2cca5f9694f9d6c8b2ff8b6a831e53b3c5"

inherit libretro-core

DESCRIPTION="A port of the SEGA Visual Memory Unit emulator VeMUlator for libretro."
HOMEPAGE="https://github.com/libretro/vemulator-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
