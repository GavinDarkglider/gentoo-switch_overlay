# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/ps2"
LIBRETRO_COMMIT_SHA="6fbf88296c0fef637a2c50064ecc8deebd577d9a"

inherit libretro-core

DESCRIPTION="pcsx2 libretro core"
HOMEPAGE="https://github.com/libretro/ps2"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/ps2-6fbf88296c0fef637a2c50064ecc8deebd577d9a/libretro"

# Upstream makefile: Makefile
