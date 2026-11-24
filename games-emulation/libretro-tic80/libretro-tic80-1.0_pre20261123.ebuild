# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/TIC-80"
LIBRETRO_COMMIT_SHA="14fd99edc29962778bc88d81773288ffc6e8aa53"

inherit cmake

SRC_URI="https://github.com/libretro/TIC-80/archive/$sha.tar.gz -> ${P}.tar.gz"

DESCRIPTION="tic80 libretro core"
HOMEPAGE="https://github.com/libretro/TIC-80"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/TIC-80-14fd99edc29962778bc88d81773288ffc6e8aa53/core"

mycmakeargs=( -DBUILD_PLAYER=OFF -DBUILD_SOKOL=OFF -DBUILD_SDL=OFF -DBUILD_DEMO_CARTS=OFF -DBUILD_LIBRETRO=ON -DBUILD_WITH_MRUBY=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_EXE_LINKER_FLAGS=-latomic )

src_install() {
	exeinto "/usr/$(get_libdir)/libretro"
	local so
	so=$(find "${BUILD_DIR}" -name '*_libretro.so' -print -quit)
	[[ -n ${so} ]] || die "libretro core shared library not built"
	doexe "${so}"
}
