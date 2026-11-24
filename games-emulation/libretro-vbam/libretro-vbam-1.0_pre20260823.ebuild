# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vbam-libretro"
LIBRETRO_COMMIT_SHA="115defb3a318258ab84746d45258a1aec19d0b4b"
inherit libretro-core

DESCRIPTION="VBA-M libretro port (Nintendo Game Boy Advance / Game Boy / Game Boy Color)"
HOMEPAGE="https://github.com/libretro/vbam-libretro"
S="${WORKDIR}/vbam-libretro-${LIBRETRO_COMMIT_SHA}/src/libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
