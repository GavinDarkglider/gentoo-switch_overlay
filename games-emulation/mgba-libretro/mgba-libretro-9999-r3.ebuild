# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION=2.8.11
CMAKE_WARN_UNUSED_CLI=1

LIBRETRO_REPO_NAME="libretro/mgba"

inherit libretro-core cmake-utils

DESCRIPTION="libretro implementation of mGBA. (Game Boy Advance)"
HOMEPAGE="https://github.com/libretro/mgba"
KEYWORDS="~arm64"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="epoxy ffmpeg gles2 imagemagick lto lzma +opengl pgo pgopost png +zip zlib"
REQUIRED_USE="
	epoxy? ( gles2 )
	gles2? ( opengl )
	pgopost? ( pgo )
	png? ( zlib )
"

DEPEND="
	epoxy? ( media-libs/libepoxy:0= )
	ffmpeg? ( virtual/ffmpeg:0= )
	imagemagick? ( media-gfx/imagemagick:0= )
	lzma? ( app-arch/xz-utils:0= )
	png? ( media-libs/libpng:0= )
	opengl? ( media-libs/mesa:0=[gles2?] )
	png? ( media-libs/libpng:0= )
	zip? ( dev-libs/libzip:0= )
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
		# For security, install into the standard games directories.
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}"/usr/share/man/man1
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/"$(get_libdir)"/libretro
		-DPGO_DIR="${T}"/pgo

		# Enable only mGBA's Libretro core as a statically linked library.
		-DBUILD_LIBRETRO=ON
		-DSKIP_LIBRARY=ON

		# Disable all mGBA-specific frontends. RetroArch is our frontend!
		-DBUILD_QT=OFF
		-DBUILD_SDL=OFF

		# Disable ARM architecture-based debugging.
		-DUSE_CLI_DEBUGGER=OFF
		-DUSE_GDB_STUB=OFF

		# Set USE flag-dependent options.
		-DUSE_EPOXY=$(usex epoxy ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DBUILD_GLES2=$(usex gles2 ON OFF)
		-DUSE_MAGICK=$(usex imagemagick ON OFF)
		-DBUILD_LTO=$(usex lto ON OFF)
		-DBUILD_GL=$(usex opengl ON OFF)
		-DBUILD_PGO=$(usex pgo ON OFF)
		-DPGO_STAGE_2=$(usex pgopost ON OFF)
		-DUSE_PNG=$(usex png ON OFF)
		-DUSE_LIBZIP=$(usex zip ON OFF)
		-DUSE_ZLIB=$(usex zlib ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	# Install the mGBA Libretro core.
	cmake-utils_src_install

	# Install the mGBA Libretro info file and enforce games-specific security
	libretro-core_src_install
}
