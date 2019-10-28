# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libretro-core epatch

DESCRIPTION="libretro implementation of mupen64plus (Nintendo64)"
HOMEPAGE="https://github.com/libretro/mupen64plus-libretro"
KEYWORDS="arm arm64"

LICENSE="GPL-2"
SLOT="0"
IUSE="gles2 vulkan"

DEPEND="media-libs/mesa:0=
		gles2? ( media-libs/mesa[gles2] )
		media-libs/libpng:0=
		dev-lang/nasm:0="
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

src_prepare() {
	default
	epatch $FILESDIR/mupen64-build-fix.patch
}

src_compile() {
	myemakeargs=(
		$(usex amd64 "WITH_DYNAREC=x86_64" "")
		$(usex x86 "WITH_DYNAREC=x86" "")
		$(usex arm "platform=rpi WITH_DYNAREC=arm" "")
		$(usex arm64 "platform=unix WITH_DYNAREC=arm64" "")
		$(usex gles2 "GLES=1 FORCE_GLES=1" "GLES=0 FORCE_GLES=0")
		$(usex vulkan "HAVE_PARALLEL=1" "HAVE_PARALLEL=0")
	)
	libretro-core_src_compile
}
