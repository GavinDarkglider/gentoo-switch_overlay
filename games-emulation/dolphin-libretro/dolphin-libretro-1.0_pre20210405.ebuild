# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dolphin"
LIBRETRO_COMMIT_SHA="d86c545a40a3065d2a7920f48d045b3435dd1a8d"
LIBRETRO_CORE_NAME="dolphin"

inherit libretro-core cmake

DESCRIPTION="A Gamecube/Wii emulator core for libretro"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/hidapi=
	dev-libs/libfmt=
	dev-libs/lzo=
	dev-libs/pugixml
	media-libs/libpng
	media-libs/libsfml
	media-libs/mesa[egl]
	net-libs/enet
	net-libs/mbedtls
	net-misc/curl
	sys-libs/readline
	sys-libs/zlib
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb
	virtual/opengl
"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

src_prepare() {
	libretro-core_src_prepare
	cmake_src_prepare
}

src_configure() {
		local mycmakeargs=(
			-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
			-DENABLE_LLVM=OFF
			-DBUILD_SHARED_LIBS=OFF
			-DLIBRETRO=ON
			-DLIBRETRO_STATIC=1
			-DENABLE_QT=0
			-DUSE_SHARED_ENET=ON
			-DCMAKE_BUILD_TYPE=Release
			-DCMAKE_INSTALL_PREFIX=/usr
		)
		cmake_src_configure
}

src_install() {
		LIBRETRO_LIB_DIR="${EROOT%/}/usr/$(get_libdir)/libretro"
		insinto "${LIBRETRO_LIB_DIR}"
		doins "${WORKDIR}/${PF}_build/${LIBRETRO_CORE_NAME}_libretro.so"
}
