# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-fsuae"
LIBRETRO_COMMIT_SHA="089bb69207fe8fa5eec0006d1d759fb6426f4027"

inherit libretro-core

DESCRIPTION="fsuae libretro core"
HOMEPAGE="https://github.com/libretro/libretro-fsuae"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-fsuae-089bb69207fe8fa5eec0006d1d759fb6426f4027"

# Upstream makefile: Makefile.libretro
