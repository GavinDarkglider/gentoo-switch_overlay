# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/tgbdual-libretro"
LIBRETRO_COMMIT_SHA="0392c9c469e653205e471114c7949c07c83bfce9"

inherit libretro-core

DESCRIPTION="tgbdual libretro core"
HOMEPAGE="https://github.com/libretro/tgbdual-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/tgbdual-libretro-0392c9c469e653205e471114c7949c07c83bfce9"
