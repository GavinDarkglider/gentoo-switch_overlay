# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-uae"
LIBRETRO_COMMIT_SHA="26e303a522b7a8f4c46b8ad32dc3d56f4357c43f"

inherit libretro-core

DESCRIPTION="WIP libretro port of UAE (P-UAE and libco), a Commodore Amiga Emulator."
HOMEPAGE="https://github.com/libretro/libretro-uae"
KEYWORDS="~amd64 ~x86 ~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
