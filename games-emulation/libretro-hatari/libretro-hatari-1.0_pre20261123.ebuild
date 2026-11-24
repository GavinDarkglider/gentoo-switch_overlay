# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/hatari"
LIBRETRO_COMMIT_SHA="4edc56f4e2add886ed5406854d12f95fdfdf67b6"

inherit cmake

SRC_URI="https://github.com/libretro/hatari/archive/4edc56f4e2add886ed5406854d12f95fdfdf67b6.tar.gz -> ${P}.tar.gz"

mycmakeargs=(
	-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
	-DENABLE_LIBRETRO=ON -DENABLE_HATARI=OFF -DENABLE_TOOLS=OFF
	-DENABLE_DSP_EMU=OFF -DENABLE_TRACING=OFF
	-DLIBRETRO_INCLUDE_DIR="${S}/src/retro/libretro-common/include"
)

DESCRIPTION="hatari libretro core"
HOMEPAGE="https://github.com/libretro/hatari"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/hatari-4edc56f4e2add886ed5406854d12f95fdfdf67b6"

# Upstream makefile: Makefile.libretro

src_install() {
	exeinto "/usr/$(get_libdir)/libretro"
	local so
	so=$(find "${BUILD_DIR}" -name '*_libretro.so' -print -quit)
	[[ -n ${so} ]] || die "libretro core shared library not built"
	doexe "${so}"
}
