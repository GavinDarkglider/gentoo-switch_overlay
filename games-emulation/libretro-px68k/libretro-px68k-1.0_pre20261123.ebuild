# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/px68k-libretro"
LIBRETRO_COMMIT_SHA="3f4f542a39a89ca63c626326fa50c4f0ea5871d7"

inherit libretro-core

DESCRIPTION="px68k libretro core"
HOMEPAGE="https://github.com/libretro/px68k-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/px68k-libretro-3f4f542a39a89ca63c626326fa50c4f0ea5871d7"

# Upstream makefile: Makefile.libretro
