# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/np2kai"
LIBRETRO_COMMIT_SHA="1ea561cd7fd62b33f4e7b3f1c2e30fc3e6089f28"
inherit libretro-core

DESCRIPTION="Neko Project II kai libretro port (NEC PC-9801 / PC-9821)"
HOMEPAGE="https://github.com/libretro/np2kai"
S="${WORKDIR}/NP2kai-${LIBRETRO_COMMIT_SHA}/sdl"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"

src_prepare() {
	eapply --binary "${FILESDIR}/libretro-np2kai-1.0_pre20260913-001-sdl-makefile.libretro-suppre.patch"
	libretro-core_src_prepare
}
