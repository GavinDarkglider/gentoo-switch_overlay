# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-lynx-libretro"
LIBRETRO_COMMIT_SHA="fcdefcfb3c11d6d2e71be076a5d3df2e88ab73ed"

inherit libretro-core

DESCRIPTION="mednafen_lynx libretro core"
HOMEPAGE="https://github.com/libretro/beetle-lynx-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-lynx-libretro-fcdefcfb3c11d6d2e71be076a5d3df2e88ab73ed"
