# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="vircon32/vircon32-libretro"
LIBRETRO_COMMIT_SHA="8b4ff35efb0f3a4c2599fa85ec0e588713f83182"

inherit libretro-core

DESCRIPTION="vircon32 libretro core"
HOMEPAGE="https://github.com/vircon32/vircon32-libretro"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vircon32-libretro-8b4ff35efb0f3a4c2599fa85ec0e588713f83182"

myemakeargs=( -DCMAKE_BUILD_TYPE=Release )
