# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/ThePowderToy"

inherit cmake libretro-core toolchain-funcs

DESCRIPTION="A port of The Powder Toy to LibRetro."
HOMEPAGE="https://github.com/libretro/ThePowderToy"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${WORKDIR}/${P}_build/src/thepowdertoy_libretro.so"
	libretro-core_src_install
}
