# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/stella2014-libretro"

inherit libretro-core

DESCRIPTION="libretro implementation of Stella 2014. (Atari 2600)"
HOMEPAGE="https://github.com/libretro/stella2014-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

