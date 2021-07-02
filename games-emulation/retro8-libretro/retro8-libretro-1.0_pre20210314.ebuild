# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/retro8"
LIBRETRO_COMMIT_SHA="31b144f3a9e2c3982e83dbcda7bd61848d0aa6e1"
inherit libretro-core

DESCRIPTION="PICO-8 implementation with SDL2 and RetroArch back-ends"
HOMEPAGE="https://github.com/libretro/retro8"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
