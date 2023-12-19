# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/xrick-libretro"

inherit libretro-core

DESCRIPTION="Xrick is an open source implementation of Rick Dangerous for libretro."
HOMEPAGE="https://github.com/libretro/xrick-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
