# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/desmume"
LIBRETRO_COMMIT_SHA="2ed78e2cece0bb9978fd64d37b17049ce2495c37"
inherit libretro-core

DESCRIPTION="Libretro implementation of DeSmuME. (Nintendo DS)"
HOMEPAGE="https://github.com/libretro/desmume"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		net-libs/libpcap
		games-emulation/libretro-info"

S="${S}/desmume/src/frontend/libretro"

src_prepare() {
	eapply "${FILESDIR}/desmume-001-arm64-build-fix.patch"
	libretro-core_src_prepare
}

src_compile() {
	myemakeargs="platform=arm64-unix"
	libretro-core_src_compile
}

