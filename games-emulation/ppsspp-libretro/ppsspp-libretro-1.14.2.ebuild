# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_COMMIT_SHA="2d1f8f03fac5f6f8322d83ec838f3a4a003bf334"
LIBRETRO_REPO_NAME="hrydgard/ppsspp"

inherit cmake libretro-core

DESCRIPTION="Libretro port of PPSSPP"
HOMEPAGE="https://www.ppsspp.org/"
SRC_URI="https://github.com/hrydgard/ppsspp/releases/download/v${PV}/ppsspp-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 JSON MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="opengl +gles2 vulkan X wayland gbm"
RESTRICT="test"
REQUIRED_USE="
	|| ( gbm wayland X )
	opengl? ( !gles2 )
	gbm? ( !X )
"

RDEPEND="
	app-arch/snappy:=
	dev-libs/libzip:=
	dev-util/glslang:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick]
	media-video/ffmpeg:0/56.58.58[pic]
	sys-libs/zlib:=
	opengl? (
		virtual/opengl
		media-libs/glew:=
		)
	gles2? ( media-libs/mesa[egl(+),gles2] )
	vulkan? ( media-libs/vulkan-loader )
	gbm? ( media-libs/mesa[gbm(+)] )
	wayland? ( media-libs/mesa[wayland] )
	X? ( media-libs/mesa[X] )
	games-emulation/libretro-info
"
DEPEND="${RDEPEND}"
ASSETS_DIR="${LIBRETRO_DATA_DIR}"/PPSSPP
S="${WORKDIR}"/ppsspp-${PV}

PATCHES=(
	"${FILESDIR}"/ppsspp-CMakeLists-flags.patch
	"${FILESDIR}"/ppsspp-disable-ccache-autodetection.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DLIBRETRO=ON
		-DHEADLESS=false
		-DUSE_DISCORD=OFF
		-DUSE_MINIUPNPC=OFF
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSING_QT_UI=OFF
		-DUSING_GLES2=$(usex gles2)
	)

	if use vulkan; then
		mycmakeargs+=( -DVULKAN=ON )
		if use gbm; then
			mycmakeargs+=( -DUSE_VULKAN_DISPLAY_KHR=ON )
		fi
		if use wayland; then
			mycmakeargs+=( -DUSE_WAYLAND_WSI=ON )
		fi
		mycmakeargs+=( -DUSING_X11_VULKAN=$(usex X) )
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}"/lib/ppsspp_libretro.so
	libretro-core_src_install

	insinto "${ASSETS_DIR}"
	doins -r "${BUILD_DIR}"/assets/*
}

pkg_postinst() {
	ewarn ""
	ewarn "You need to symlink \"/${ASSETS_DIR}\""
	ewarn "to the \"system_directory/\" directory of your user."
	ewarn "As retroarch user:"
	ewarn "When upgrading from old assets:"
	ewarn "\$ rm -r ~/.config/retroarch/system/PPSSPP/"
	ewarn "To symlink the assets:"
	ewarn "\$ mkdir -p ~/.config/retroarch/system"
	ewarn "\$ ln -s /${ASSETS_DIR} ~/.config/retroarch/system/"
	ewarn ""
	ewarn ""
}
