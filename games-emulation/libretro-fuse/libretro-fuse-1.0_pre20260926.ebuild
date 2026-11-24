# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
LIBRETRO_REPO_NAME="libretro/fuse-libretro"
LIBRETRO_COMMIT_SHA="e997e2bc32c888348f862f69f2c53babfedf7791"

inherit libretro-core

DESCRIPTION="A port of the Fuse Unix Spectrum Emulator to libretro"
HOMEPAGE="https://github.com/libretro/fuse-libretro"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
