# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/frodo-libretro"

inherit libretro-core

DESCRIPTION="Commdoore 64 emulator for libretro"
HOMEPAGE="https://github.com/libretro/frodo-libretro"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_compile() {
	libretro-core_src_compile
}
