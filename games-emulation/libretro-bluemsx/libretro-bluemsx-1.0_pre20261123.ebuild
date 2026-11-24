# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/blueMSX-libretro"
LIBRETRO_COMMIT_SHA="112fa5628aef071afe63619b6a2dc473d5640d39"

inherit libretro-core

DESCRIPTION="bluemsx libretro core"
HOMEPAGE="https://github.com/libretro/blueMSX-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/blueMSX-libretro-112fa5628aef071afe63619b6a2dc473d5640d39"

# Upstream makefile: Makefile.libretro
