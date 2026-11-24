# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vice-libretro"
LIBRETRO_COMMIT_SHA="76cde0b2cc4e52106618f2cc5d9d1112d9205c89"

inherit libretro-core

DESCRIPTION="Versatile Commodore 8-bit Emulator as a libretro core"
HOMEPAGE="https://github.com/libretro/vice-libretro"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"

src_compile() {
	# Extracting the EMUTYPE from PN (e.g. libretro-vice-x64sc -> x64sc)
	local emutype=${PN#libretro-vice-}
	myemakeargs=(
		EMUTYPE="${emutype}"
	)
	libretro-core_src_compile
}
