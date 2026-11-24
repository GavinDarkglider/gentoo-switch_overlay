# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/xrick-libretro"
LIBRETRO_COMMIT_SHA="fcfde3623a04b4e986548e06d46630fcd0bd1e18"

inherit libretro-core

S="${WORKDIR}/xrick-libretro-fcfde3623a04b4e986548e06d46630fcd0bd1e18"

DESCRIPTION="xrick libretro core"
HOMEPAGE="https://github.com/libretro/xrick-libretro.git"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile
