# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/FreeIntv"
LIBRETRO_COMMIT_SHA="ef3e0fe322bec62a7f916c0bb0834c08c348d0b4"
inherit libretro-core

DESCRIPTION="FreeIntv libretro port (Mattel Intellivision)"
HOMEPAGE="https://github.com/libretro/FreeIntv"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
