# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/yabause"
# Upstream Makefile still produces yabause_libretro.so.
LIBRETRO_CORE_NAME="yabause"
LIBRETRO_COMMIT_SHA="8926b0c6c347f8c5c755911ddb0ac695420ffbf8"

inherit libretro-core

DESCRIPTION="Sega Saturn Emulated Hardware"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="
	dev-libs/libbsd
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb
"
DEPEND="${RDEPEND}"

MY_S="${WORKDIR}/yabause-${LIBRETRO_COMMIT_SHA}"
S="${MY_S}/yabause/src/libretro"

src_prepare() {
	eapply "${FILESDIR}/yabasanshiro-3.4.2_pre20260530-001-no-sse-on-arm64.patch"
	libretro-core_src_prepare
}

src_compile() {
	myemakeargs=( "platform=unix" )
	libretro-core_src_compile
}
