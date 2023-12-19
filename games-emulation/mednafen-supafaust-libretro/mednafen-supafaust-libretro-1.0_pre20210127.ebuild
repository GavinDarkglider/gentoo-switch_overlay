# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/supafaust"
LIBRETRO_COMMIT_SHA="927b3a1f5e5b6689a1ff4d37ad42814e29ee0148"

inherit libretro-core

DESCRIPTION="Unsupported SNES emulator for multicore ARM linux plataforms"
HOMEPAGE="https://github.com/libretro/supafaust"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
