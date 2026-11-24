# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/yabause"
LIBRETRO_COMMIT_SHA="8926b0c6c347f8c5c755911ddb0ac695420ffbf8"

inherit libretro-core

DESCRIPTION="kronos libretro core"
HOMEPAGE="https://github.com/libretro/yabause"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/yabause-8926b0c6c347f8c5c755911ddb0ac695420ffbf8/yabause/src/libretro"
