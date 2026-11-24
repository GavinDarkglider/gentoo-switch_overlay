# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/81-libretro"
LIBRETRO_COMMIT_SHA="fa7094910d040baa5fd8b11dbf6a1a618330ecd9"

inherit libretro-core

# Upstream produces 81_libretro.so.
LIBRETRO_CORE_NAME="81"

DESCRIPTION="81 libretro core"
HOMEPAGE="https://github.com/libretro/81-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/81-libretro-fa7094910d040baa5fd8b11dbf6a1a618330ecd9"

# Upstream makefile: Makefile.libretro
