# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/hatari"
LIBRETRO_COMMIT_SHA="cea06eebf695b078fadc0e78bb0f2b2baaca799f"

inherit libretro-core

DESCRIPTION="Hatari is an Atari ST/STE/TT/Falcon emulator core for libretro"
HOMEPAGE="https://github.com/libretro/hatari"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_configure() {
	# Skip the ./configure script.
	true
}
