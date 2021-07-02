# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/swanstation"

inherit git-r3 libretro-core cmake

DESCRIPTION="Fast Sony Playstation emulator."
HOMEPAGE="https://github.com/libretro/swanstation"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
		media-libs/vulkan-loader
"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_configure() {
		local mycmakeargs=(
			-DBUILD_LIBRETRO_CORE=ON
			-DBUILD_SDL_FRONTEND=OFF
			-DBUILD_QT_FRONTEND=OFF
			-DENABLE_DISCORD_PRESENCE=OFF
			-DCMAKE_BUILD_TYPE=Release
			-DENABLE_CHEEVOS=ON
			-DBUILD_SHARED_LIBS=OFF
		)
		cmake_src_configure
}

src_install() {
		LIBRETRO_LIB_DIR="${EROOT%/}/usr/$(get_libdir)/libretro"
		insinto "${LIBRETRO_LIB_DIR}"
		doins "${WORKDIR}/${PF}_build/${LIBRETRO_CORE_NAME}_libretro.so"
}
