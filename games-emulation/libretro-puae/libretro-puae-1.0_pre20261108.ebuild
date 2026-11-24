# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-uae"
LIBRETRO_COMMIT_SHA="d366f77c60e5a5f059f129cc3773d3048306083b"

inherit libretro-core

DESCRIPTION="WIP libretro port of UAE (P-UAE and libco), a Commodore Amiga Emulator"
HOMEPAGE="https://github.com/libretro/libretro-uae"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
