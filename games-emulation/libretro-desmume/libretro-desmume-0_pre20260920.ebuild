# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/desmume"
LIBRETRO_COMMIT_SHA="95b4d798731caa809125b6c3c11d17cc332ff6ef"

inherit libretro-core

DESCRIPTION="Port of Nintendo DS emulator DeSmuME to libretro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	>=net-libs/libpcap-1.8.1-r2
"

S="${S}/desmume/src/frontend/libretro"

src_prepare() {
	eapply "${FILESDIR}/desmume-0_pre20250315-001-arm64-build-fix.patch"
	libretro-core_src_prepare
}

src_compile() {
	myemakeargs=( "platform=arm64-unix" )
	libretro-core_src_compile
}
