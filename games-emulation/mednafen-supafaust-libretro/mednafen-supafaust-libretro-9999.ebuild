# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/supafaust"

inherit libretro-core

DESCRIPTION="Unsupported SNES emulator for multicore ARM linux plataforms"
HOMEPAGE="https://github.com/libretro/supafaust"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
