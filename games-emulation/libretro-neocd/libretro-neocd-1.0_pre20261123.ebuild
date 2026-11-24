# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/neocd_libretro"
LIBRETRO_COMMIT_SHA="b1e04c738cb48a1dae0574b8877f6a116d270ca1"

inherit libretro-core

DESCRIPTION="neocd libretro core"
HOMEPAGE="https://github.com/libretro/neocd_libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/neocd_libretro-b1e04c738cb48a1dae0574b8877f6a116d270ca1"

# Upstream makefile: Makefile
