# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="nesbox/TIC-80"

inherit cmake libretro-core toolchain-funcs

DESCRIPTION="TIC-80 is a fantasy computer for making, playing and sharing tiny games."
HOMEPAGE="https://github.com/nesbox/TIC-80"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLAYER=OFF
		-DBUILD_SOKOL=OFF
		-DBUILD_SDL=OFF
		-DBUILD_DEMO_CARTS=OFF
		-DBUILD_LIBRETRO=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${WORKDIR}/${P}_build/lib/tic80_libretro.so"
	libretro-core_src_install
}
