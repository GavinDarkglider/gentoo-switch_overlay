# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/snes9x2010"
LIBRETRO_COMMIT_SHA="82904a95e9bab2c3e63395e4b9ece8fdca8b785d"

inherit libretro-core

DESCRIPTION="snes9x2010 libretro core"
HOMEPAGE="https://github.com/libretro/snes9x2010"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/snes9x2010-82904a95e9bab2c3e63395e4b9ece8fdca8b785d"

# Upstream makefile: Makefile.libretro
