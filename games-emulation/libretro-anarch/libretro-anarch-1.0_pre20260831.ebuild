# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="iyzsong/anarch-libretro"
LIBRETRO_COMMIT_SHA="187050344ef440c4eaf3135304a020093564fa3f"

inherit libretro-core

S="${WORKDIR}/anarch-libretro/build"

DESCRIPTION="anarch libretro core"
HOMEPAGE="https://codeberg.org/iyzsong/anarch-libretro.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile
