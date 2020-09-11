# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/parallel-n64"

inherit libretro-core

DESCRIPTION="Rewritten Nintendo 64 emulator made specifically for Libretro."
HOMEPAGE="https://github.com/libretro/parallel-n64"
KEYWORDS="amd64 x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="gles2 vulkan"

RDEPEND="media-libs/mesa:0=
	gles2? ( media-libs/mesa[gles2] )
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	dev-lang/nasm:0=
	games-emulation/libretro-info"

src_compile() {
	myemakeargs=(
		$(usex amd64 "WITH_DYNAREC=x86_64 HAVE_PARALLEL=1 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1" "")
		$(usex x86 "WITH_DYNAREC=x86 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1" "")
		$(usex arm "platform=rpi WITH_DYNAREC=arm" "")
		$(usex arm64 "platform=rpi WITH_DYNAREC=aarch64" "")
		$(usex gles2 "FORCE_GLES=1" "FORCE_GLES=0")
		$(usex vulkan "HAVE_PARALLEL=1" "HAVE_PARALLEL=0")
	)
	libretro-core_src_compile
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}
