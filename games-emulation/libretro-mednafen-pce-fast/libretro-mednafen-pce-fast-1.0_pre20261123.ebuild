# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-pce-fast-libretro"
LIBRETRO_COMMIT_SHA="4cf066e22533186d0cfad85a0fec2aced93e4e29"

inherit libretro-core

DESCRIPTION="mednafen_pce_fast libretro core"
HOMEPAGE="https://github.com/libretro/beetle-pce-fast-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-pce-fast-libretro-4cf066e22533186d0cfad85a0fec2aced93e4e29"
