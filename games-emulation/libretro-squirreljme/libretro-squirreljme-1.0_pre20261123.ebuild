# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="XerTheSquirrel/SquirrelJME"
LIBRETRO_COMMIT_SHA="76f78ede288cf6625dbf3725e26996c8918a5870"

inherit cmake

PATCHES=( "${FILESDIR}/squirreljme-1.0_pre20261123-001-host-ldflags.patch" )

SRC_URI="https://github.com/XerTheSquirrel/SquirrelJME/archive/76f78ede288cf6625dbf3725e26996c8918a5870.tar.gz -> ${P}.tar.gz"

DESCRIPTION="squirreljme libretro core"
HOMEPAGE="https://github.com/XerTheSquirrel/SquirrelJME"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/SquirrelJME-76f78ede288cf6625dbf3725e26996c8918a5870/nanocoat"

mycmakeargs=( -DCMAKE_BUILD_TYPE=Release -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY )

src_install() {
	exeinto "/usr/$(get_libdir)/libretro"
	local so
	so=$(find "${BUILD_DIR}" -name '*_libretro.so' -print -quit)
	[[ -n ${so} ]] || die "libretro core shared library not built"
	doexe "${so}"
}

src_configure() {
	# CMake builds host tools via make; cross LDFLAGS must not leak there.
	local saved_ldflags=${LDFLAGS}
	export LDFLAGS=
	cmake_src_configure
	export LDFLAGS=${saved_ldflags}
}
