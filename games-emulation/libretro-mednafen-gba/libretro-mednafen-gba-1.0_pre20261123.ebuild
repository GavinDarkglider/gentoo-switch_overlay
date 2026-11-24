# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-gba-libretro"
LIBRETRO_COMMIT_SHA="b158166237b17253188cfdbe73a8a0b9fe4b3a8c"

inherit libretro-core

DESCRIPTION="mednafen_gba libretro core"
HOMEPAGE="https://github.com/libretro/beetle-gba-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-gba-libretro-b158166237b17253188cfdbe73a8a0b9fe4b3a8c"
