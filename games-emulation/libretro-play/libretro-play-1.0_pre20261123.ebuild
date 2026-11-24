# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/Play-"
LIBRETRO_COMMIT_SHA="884ae3b96c631f235cd18b2643d1f318fa6951fb"

inherit cmake

PATCHES=( "${FILESDIR}/play-1.0_pre20261123-001-stdexcept.patch" )

SRC_URI="https://github.com/libretro/Play-/archive/884ae3b96c631f235cd18b2643d1f318fa6951fb.tar.gz -> ${P}.tar.gz"

DESCRIPTION="play libretro core"
HOMEPAGE="https://github.com/libretro/Play-"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Play--884ae3b96c631f235cd18b2643d1f318fa6951fb"

src_install() {
	exeinto "/usr/$(get_libdir)/libretro"
	local so
	so=$(find "${BUILD_DIR}" -name '*_libretro.so' -print -quit)
	[[ -n ${so} ]] || die "libretro core shared library not built"
	doexe "${so}"
}

mycmakeargs=(
	-DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF
	-DBUILD_LIBRETRO_CORE=ON -DBUILD_PLAY=OFF -DBUILD_PSFPLAYER=OFF
	-DENABLE_AMAZON_S3=ON -DUSE_GLEW=OFF -DUSE_GLES=ON
	-DTARGET_PLATFORM_UNIX_AARCH64=YES -DCMAKE_BUILD_TYPE=Release
)
