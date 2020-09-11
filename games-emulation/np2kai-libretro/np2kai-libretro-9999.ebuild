# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/NP2kai"

inherit libretro-core

DESCRIPTION="NP2kai is PC-9801 series emulator"
HOMEPAGE="https://github.com/libretro/NP2kai"
KEYWORDS="~arm64"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/sdl"
