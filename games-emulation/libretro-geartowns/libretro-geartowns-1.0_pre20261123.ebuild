# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="drhelius/Geartowns"
LIBRETRO_COMMIT_SHA="877fb9b33d1e8f85362be37d2f4e2c86515ae0d9"

inherit libretro-core

DESCRIPTION="geartowns libretro core"
HOMEPAGE="https://github.com/drhelius/Geartowns"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Geartowns-877fb9b33d1e8f85362be37d2f4e2c86515ae0d9/platforms/libretro"

# Upstream makefile: Makefile
