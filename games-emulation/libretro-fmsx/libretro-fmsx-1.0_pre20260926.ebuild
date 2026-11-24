# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fmsx-libretro"
LIBRETRO_COMMIT_SHA="4de11755ce4f196ac1c8a7bb20bb4eccbc87a7d4"

inherit libretro-core

DESCRIPTION="Port of fMSX to the libretro API"
HOMEPAGE="https://github.com/libretro/fmsx-libretro"
LICENSE="fMSX"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
