# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="libretro/${PN//-libretro}"
inherit libretro-core cmake-utils

DESCRIPTION="libretro implementation of Dolphin. (Nintendo GC/Wii)"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS="arm arm64"

LICENSE="GPL-2"
SLOT="0"
IUSE="opengl vulkan -clang"

DEPEND="opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader:0= )"

RDEPEND="${DEPEND}
		games-emulation/libretro-info"

#S="${S}"/Source/Core/DolphinLibretro
#S="${S}"/dolphin-libretro-9999/
EGIT_OVERRIDE_COMMIT_LIBRETRO_DOLPHIN="a5bce7d"

src_compile() {
	mycmakeargs=(
		$(usex opengl "-DHAVE_OPENGL_CORE=1" "-DHAVE_OPENGL_CORE=0")
		$(usex vulkan "-DHAVE_VULKAN=1" "=-DHAVE_VULKAN=0")
		$(usex clang  "-DCLANG=0" "=DCLANG=0")
		-DLIBRETRO=1
		-DSTATIC_LINKING=0
	)
	cmake-utils_src_configure
	cd "${WORKDIR}"/dolphin-libretro-9999_build
	emake
}

src_install() {
	dodir usr/lib64/libretro
	cp "${WORKDIR}"/dolphin-libretro-9999_build/dolphin_libretro.so "${D}"/usr/lib64/libretro/
}
