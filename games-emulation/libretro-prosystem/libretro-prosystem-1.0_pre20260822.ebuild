# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/prosystem-libretro"
LIBRETRO_COMMIT_SHA="8a88014287c7a01cd568067e5a557d0a2b2a051f"
inherit libretro-core

DESCRIPTION="ProSystem libretro port (Atari 7800)"
HOMEPAGE="https://github.com/libretro/prosystem-libretro"
LICENSE="GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
