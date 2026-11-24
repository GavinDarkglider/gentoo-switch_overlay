# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-bsnes-libretro"
LIBRETRO_COMMIT_SHA="5f05e4c785e936c928ac468e129c55b6f08592cb"

inherit libretro-core

PATCHES=( "${FILESDIR}/libretro-mednafen-snes-1.0_pre20261123-001-gnu-inline.patch"
	"${FILESDIR}/libretro-mednafen-snes-1.0_pre20261123-002-static-strl.patch" )

DESCRIPTION="mednafen_snes libretro core"
HOMEPAGE="https://github.com/libretro/beetle-bsnes-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-bsnes-libretro-5f05e4c785e936c928ac468e129c55b6f08592cb"
