# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/daphne"
#LIBRETRO_COMMIT_SHA="7e5cac88d0509c6f4722100c5b8a9b5ee91f404a"

inherit libretro-core

DESCRIPTION="Arcade laserdisc libretro core"
HOMEPAGE="https://github.com/libretro/daphne"
KEYWORDS="amd64 x86 arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

