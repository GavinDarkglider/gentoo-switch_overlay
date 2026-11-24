# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-simcoupe"
LIBRETRO_COMMIT_SHA="c28046241ac6a4d79e55326b6e354dc02f92fa34"

inherit libretro-core

DESCRIPTION="simcp libretro core"
HOMEPAGE="https://github.com/libretro/libretro-simcoupe"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-simcoupe-c28046241ac6a4d79e55326b6e354dc02f92fa34"
