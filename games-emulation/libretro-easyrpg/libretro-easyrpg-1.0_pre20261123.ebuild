# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="EasyRPG/Player"
LIBRETRO_COMMIT_SHA="a99ca834b8560f6a39a4df5de2d3972523ba2f30"

inherit libretro-core

DESCRIPTION="easyrpg libretro core"
HOMEPAGE="https://github.com/EasyRPG/Player"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Player-a99ca834b8560f6a39a4df5de2d3972523ba2f30"

myemakeargs=( -DPLAYER_TARGET_PLATFORM=libretro -DBUILD_SHARED_LIBS=ON )
