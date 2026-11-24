# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2003-plus-libretro"
LIBRETRO_COMMIT_SHA="faecd95848afa89691ea1af45df96ac8c924838b"
inherit libretro-core

DESCRIPTION="MAME (0.78) with extra features for libretro"
HOMEPAGE="https://github.com/libretro/mame2003-plus-libretro"
LICENSE="MAME-GPL"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"

LIBRETRO_CORE_LIB_FILE="${S}"/mame2003_plus_libretro.so
