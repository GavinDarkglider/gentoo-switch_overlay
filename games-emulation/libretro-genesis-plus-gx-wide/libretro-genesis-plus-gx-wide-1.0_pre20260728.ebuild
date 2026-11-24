# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Genesis-Plus-GX-Wide"
LIBRETRO_COMMIT_SHA="b7ad005431f5f0b55e559f6d598d1ed2479bf13b"

inherit libretro-core

S="${WORKDIR}/Genesis-Plus-GX-Wide-b7ad005431f5f0b55e559f6d598d1ed2479bf13b"

DESCRIPTION="genesis_plus_gx_wide libretro core"
HOMEPAGE="https://github.com/libretro/Genesis-Plus-GX-Wide.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile.libretro
