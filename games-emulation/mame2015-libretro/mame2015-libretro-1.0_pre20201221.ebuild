# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mame2015-libretro"
LIBRETRO_COMMIT_SHA="ef41361dc9c88172617f7bbf6cd0ead4516a3c3f"
inherit libretro-core

DESCRIPTION="MAME (0.160) for libretro."
HOMEPAGE="https://github.com/libretro/mame2015-libretro"
KEYWORDS="~arm64"

LICENSE="MAME-GPL"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

PATCHES=("${FILESDIR}/python.patch")
