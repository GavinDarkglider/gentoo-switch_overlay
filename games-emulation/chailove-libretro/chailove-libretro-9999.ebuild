# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-chailove"

inherit libretro-core

DESCRIPTION="2D Game Framework with ChaiScript"
HOMEPAGE="https://github.com/libretro/libretro-chailove"
KEYWORDS="~arm64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_compile (){
		emake -f Makefile
}
