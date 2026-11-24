# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-pocketcdg"
LIBRETRO_COMMIT_SHA="c6fc08d942753342686cb9494e1d285a14c1893c"

inherit libretro-core

DESCRIPTION="pocketcdg libretro core"
HOMEPAGE="https://github.com/libretro/libretro-pocketcdg"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-pocketcdg-c6fc08d942753342686cb9494e1d285a14c1893c"

# Upstream makefile: Makefile
