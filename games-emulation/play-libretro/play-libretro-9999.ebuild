# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Play-"
LIBRETRO_COMMIT_SHA="884ae3b96c631f235cd18b2643d1f318fa6951fb"

inherit libretro-core cmake ninja-utils

DESCRIPTION="Sony Playstation 2 libretro core"
HOMEPAGE="https://github.com/libretro/Play-"
KEYWORDS="amd64 x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

# S=${S}/Source/ui_libretro

src_configure(){
	local mycmakeargs=( 
	-BUILD_LIBRETRO_CORE=ON 
	-BUILD_PLAY=OFF 
)
	cmake_src_configure
	eninja
}

src_compile() {
	cmake_src_compile
}

