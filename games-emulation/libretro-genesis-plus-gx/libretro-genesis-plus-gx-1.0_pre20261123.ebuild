# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Genesis-Plus-GX"
LIBRETRO_COMMIT_SHA="099c962e7374eb84cae9bba180c9e0e49e767b40"
inherit libretro-core

DESCRIPTION="libretro implementation of Genesis Plus GX. \
(Sega Genesis/Sega CD)"
HOMEPAGE="https://github.com/libretro/Genesis-Plus-GX"
LICENSE="GPGX"
SLOT="0"
KEYWORDS="arm64"

DEPEND="virtual/zlib"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

LIBRETRO_CORE_NAME=genesis_plus_gx
