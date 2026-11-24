# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fixNES"
LIBRETRO_COMMIT_SHA="72af6c6fd9d3b6c23d334ba7385b6a09225f2276"

inherit libretro-core

DESCRIPTION="fixnes libretro core"
HOMEPAGE="https://github.com/libretro/fixNES"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/fixNES-72af6c6fd9d3b6c23d334ba7385b6a09225f2276/libretro"
