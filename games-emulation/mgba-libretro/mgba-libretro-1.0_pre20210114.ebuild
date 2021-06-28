# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mgba"
LIBRETRO_COMMIT_SHA="4ffa98c8dd83853550c3030da3cae3f1deb6e0ab"

inherit libretro-core cmake

DESCRIPTION="libretro implementation of mGBA. (Game Boy Advance)"
HOMEPAGE="https://github.com/libretro/mgba"
KEYWORDS="~arm64 ~x86"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="epoxy ffmpeg +gles2 lto lzma +opengl pgo pgopost png +zip zlib"
REQUIRED_USE="
	epoxy? ( gles2 )
	gles2? ( opengl )
	pgopost? ( pgo )
	png? ( zlib )
"

DEPEND="
	epoxy? ( media-libs/libepoxy:0= )
	ffmpeg? ( virtual/ffmpeg:0= )
	lzma? ( app-arch/xz-utils:0= )
	png? ( media-libs/libpng:0= )
	opengl? ( media-libs/mesa:0=[gles2?] )
	png? ( media-libs/libpng:0= )
	zlib? ( sys-libs/zlib:0= )
"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_unpack() {
	libretro-core_src_unpack

	# For safety, unbundle most bundled third-party libraries.
	mkdir "${S}"/src/third-party-unused
	mv \
		"${S}"/src/third-party/{libpng,lzma,zlib} \
		"${S}"/src/third-party-unused/
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIBRETRO=ON
		-DSKIP_LIBRARY=ON
		-DBUILD_QT=OFF
		-DBUILD_SDL=OFF
		-DUSE_GDB_STUB=OFF
		-DUSE_EPOXY=$(usex epoxy ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DBUILD_GLES2=$(usex gles2 ON OFF)
		-DBUILD_LTO=$(usex lto ON OFF)
		-DBUILD_GL=$(usex opengl ON OFF)
		-DBUILD_PGO=$(usex pgo ON OFF)
		-DPGO_STAGE_2=$(usex pgopost ON OFF)
		-DUSE_PNG=$(usex png ON OFF)
		-DUSE_ZLIB=$(usex zlib ON OFF)
	)
	cmake_src_configure
}

src_install() {
		LIBRETRO_LIB_DIR="${EROOT%/}/usr/$(get_libdir)/libretro"
		insinto "${LIBRETRO_LIB_DIR}"
		doins "${WORKDIR}/${PF}_build/${LIBRETRO_CORE_NAME}_libretro.so"
}
