# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/ThePowderToy"
LIBRETRO_COMMIT_SHA="bb2d9f6623d2ccf25a0021045af9591c8a0bbaff"

inherit cmake

SRC_URI="https://github.com/libretro/ThePowderToy/archive/bb2d9f6623d2ccf25a0021045af9591c8a0bbaff.tar.gz -> ${P}.tar.gz"

DESCRIPTION="thepowdertoy libretro core"
HOMEPAGE="https://github.com/libretro/ThePowderToy"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/ThePowderToy-bb2d9f6623d2ccf25a0021045af9591c8a0bbaff"

mycmakeargs=( -DBUILD_LIBRETRO=ON -DCMAKE_BUILD_TYPE=Release )

src_install() {
	exeinto "/usr/$(get_libdir)/libretro"
	local so
	so=$(find "${BUILD_DIR}" -name '*_libretro.so' -print -quit)
	[[ -n ${so} ]] || die "libretro core shared library not built"
	doexe "${so}"
}
