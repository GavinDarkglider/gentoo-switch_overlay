# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-uzem"
LIBRETRO_COMMIT_SHA="faa6c67ce9bc2d1540c9ace78e63124202c5eb44"

inherit libretro-core

DESCRIPTION="An emulator for development purposes"
HOMEPAGE="https://github.com/libretro/libretro-uzem"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

