# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="WizzardSK/cemu-libretro"
LIBRETRO_COMMIT_SHA="dbf18093970bd3091e201a0a893eacd0256f9c26"

inherit libretro-core

DESCRIPTION="cemu libretro core"
HOMEPAGE="https://github.com/WizzardSK/cemu-libretro"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/cemu-libretro-dbf18093970bd3091e201a0a893eacd0256f9c26"

myemakeargs=( -DENABLE_LIBRETRO=ON -DENABLE_BLUEZ=OFF -DENABLE_FERAL_GAMEMODE=OFF )
