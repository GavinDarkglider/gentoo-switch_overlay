# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="Multiplatform Sega Dreamcast emulator"
HOMEPAGE="https://github.com/flyinghead/flycast"
SRC_URI="
	https://github.com/flyinghead/flycast/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/libsdl-org/SDL/archive/b424665e0899769b200231ba943353a5fee1b6b6.tar.gz -> ${P}-core_deps_SDL.tar.gz
	https://github.com/flyinghead/mingw-breakpad/archive/d2657e1267d2ce9399bcc6b9c5b01b465db057b1.tar.gz -> ${P}-core_deps_breakpad.tar.gz
	https://github.com/rtissera/libchdr/archive/d3ffd20ca71686877372dea7f9eed359dbf65ba2.tar.gz -> ${P}-core_deps_libchdr.tar.gz
	https://github.com/vinniefalco/LuaBridge/archive/fab7b33b896a42dcc865ba5ecdbacd9f409137f8.tar.gz -> ${P}-core_deps_luabridge.tar.gz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="gles +opengl vulkan"

REQUIRED_USE="
	|| ( gles opengl )
	opengl? ( !gles )
"

RDEPEND="
	opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
	gles? ( media-libs/mesa[egl(+),gles2] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/ninja
	dev-util/cmake
"

PATCHES=(
    "${FILESDIR}/v2.0-vk:_don't_sort_triangles_in_per-strip_mode.patch"
)

S="${WORKDIR}/flycast-${PV}"
BUILD_DIR="${WORKDIR}/${P}_build"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}" || die
	local list=(
		core_deps_SDL
		core_deps_breakpad
		core_deps_libchdr
		core_deps_luabridge
	)

	local i
	for i in "${list[@]}"; do
		tar xf "${DISTDIR}/${P}-${i}.tar.gz" --strip-components 1 -C "${i//_//}" ||
			die "Failed to unpack ${P}-${i}.tar.gz"
	done
}

src_configure() {
	mkdir "${BUILD_DIR}"
	pushd  "${BUILD_DIR}"

	local mycmakeargs=(
		-DLIBRETRO=ON
		-DUSE_OPENMP=OFF
		-DUSE_GLES2=$(usex gles)
		-DUSE_VULKAN=$(usex vulkan)
		$(usex arm "-DARMv7=ON" "")
		$(usex arm64 "-DARM64=ON" "")
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake "${mycmakeargs[@]}" -GNinja "${S}"

	find . -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
	find . -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;

	popd
}

src_compile() {
	pushd "${BUILD_DIR}"

	ninja -v ${makeopts_jobs}

	popd
}

src_install() {
	local libretro_lib_dir="/usr/$(get_libdir)/libretro"
	exeinto "${libretro_lib_dir}"
	doexe "${BUILD_DIR}"/flycast_libretro.so
}
