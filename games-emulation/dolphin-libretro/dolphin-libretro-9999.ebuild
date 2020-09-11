# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dolphin"
LIBRETRO_COMMIT_SHA="c36ae84b966327bd9d78d3eabf2309f82d37792e"

inherit libretro-core cmake-utils

DESCRIPTION="A Gamecube/Wii emulator core for libretro"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS="amd64 arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_configure() {
		local mycmakeargs=(
			-DLIBRETRO=ON
			-DLIBRETRO_STATIC=1
			-DCMAKE_BUILD_TYPE=Release
			-DCMAKE_INSTALL_PREFIX=/usr
		)
		cmake-utils_src_configure
}

src_install() {
		cmake-utils_src_install
		libretro-core_src_install
}

