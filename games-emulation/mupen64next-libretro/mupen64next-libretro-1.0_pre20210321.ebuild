# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mupen64plus-libretro-nx"
LIBRETRO_COMMIT_SHA="a6a6bfd56c8a8d6077182c280bf9eb33c7fba0e8"
LIBRETRO_CORE_NAME="mupen64plus_next"

inherit libretro-core

DESCRIPTION="Improved mupen64plus libretro core reimplementation"
HOMEPAGE="https://github.com/libretro/mupen64plus-libretro-nx"
KEYWORDS="~amd64 ~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="gles2 gles3 vulkan"

RDEPEND="media-libs/mesa:0=
	gles2? ( media-libs/mesa[gles2] )
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	dev-lang/nasm:0=
	games-emulation/libretro-info"

src_compile() {
	myemakeargs=(
		$(usex amd64 "ARCH=x86_64 WITH_DYNAREC=x86_64 HAVE_PARALLEL_RDP=1 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1 HAVE_LLE=1" "")
		$(usex x86 "WITH_DYNAREC=x86 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1" "")
		$(usex arm "platform=rpi WITH_DYNAREC=arm" "")
		$(usex arm64 "platform=rpi WITH_DYNAREC=aarch64" "")
		$(usex gles2 "FORCE_GLES=1" "FORCE_GLES=0")
		$(usex gles3 "FORCE_GLES3=1" "FORCE_GLES=0")
		$(usex vulkan "HAVE_PARALLEL=1" "HAVE_PARALLEL=0")
	)
	libretro-core_src_compile
}
