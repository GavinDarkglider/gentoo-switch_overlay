# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_COMMIT_SHA="ce0a45cf0fcdd5bebf32208b9998f68dfc1107b7"
LIBRETRO_REPO_NAME="hrydgard/ppsspp"

inherit cmake libretro-core

DESCRIPTION="Libretro port of PPSSPP"
HOMEPAGE="https://www.ppsspp.org/"
SRC_URI="
	https://github.com/hrydgard/ppsspp/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Cross/archive/9acb9ec31f5a8ef80ea6b994bb77be787b08d3d1.tar.gz -> ${P}-ext_SPIRV-Cross.tar.gz
	https://github.com/Kingcom/armips/archive/6719edebaae03330ee5441d9b28280672edf00d5.tar.gz -> ${P}-ext_armips.tar.gz
	https://github.com/Tencent/rapidjson/archive/73063f5002612c6bf64fe24f851cd5cc0d83eef9.tar.gz -> ${P}-ext_rapidjson.tar.gz
	https://github.com/facebook/zstd/archive/096dccbc2d89a560db0b9892c53ea0c77eff20a1.tar.gz -> ${P}-ext_zstd.tar.gz
	https://github.com/hrydgard/glslang/archive/dc11adde23c455a24e13dd54de9b4ede8bdd7db8.tar.gz -> ${P}-ext_glslang.tar.gz
	https://github.com/hrydgard/miniupnp/archive/3a87be33e797ba947b2b2a5f8d087f6c3ff4d93e.tar.gz -> ${P}-ext_miniupnp.tar.gz
	https://github.com/hrydgard/ppsspp-freetype/archive/cbea79dc8fef4d9210e2bac7e7b9b5ff3388197a.tar.gz -> ${P}-ext_native_tools_prebuilt.tar.gz
	https://github.com/hrydgard/ppsspp-lang/archive/3bf6b18eb0ae68861fbfbb7b43cd764771ca42a9.tar.gz -> ${P}-assets_lang.tar.gz
	https://github.com/Kingcom/filesystem/archive/3f1c185ab414e764c694b8171d1c4d8c5c437517.tar.gz -> ${P}-ext_armips_ext_filesystem.tar.gz
"

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
	media-video/ffmpeg[pic]
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

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}" || die
	local list=(
		assets_lang
		ext_SPIRV-Cross
		ext_armips
		ext_glslang
		ext_miniupnp
		ext_native_tools_prebuilt
		ext_rapidjson
		ext_zstd
		ext_armips_ext_filesystem
	)

	local i
	for i in "${list[@]}"; do
		tar xf "${DISTDIR}/${P}-${i}.tar.gz" --strip-components 1 -C "${i//_//}" ||
			die "Failed to unpack ${P}-${i}.tar.gz"
	done
}

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
