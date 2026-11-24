# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2015-libretro"
LIBRETRO_COMMIT_SHA="7adbf440d5f554097f58f8c6ebb673adc4320a31"

inherit libretro-core

DESCRIPTION="mame2015 libretro core"
HOMEPAGE="https://github.com/libretro/mame2015-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2015-libretro-7adbf440d5f554097f58f8c6ebb673adc4320a31"

myemakeargs=( PTR64=1 LIBRETRO_CPU=arm64 PLATFORM=arm64 ARCHOPTS="-D__aarch64__" CROSS_BUILD=1 TARGET=mame SUBTARGET=mame OSD=retro CONFIG=libretro NOWERROR=1 REGENIE=1 )

src_compile() {
	export PATH="/host-tools/bin:${PATH}"
	local args=(
		PTR64=1 LIBRETRO_CPU=arm64 PLATFORM=arm64
		ARCHOPTS="-D__aarch64__" CROSS_BUILD=1
		OVERRIDE_CC="$(tc-getCC)" OVERRIDE_CXX="$(tc-getCXX)" OVERRIDE_LD="$(tc-getCXX)"
		CONFIG=libretro TARGET=mame SUBTARGET=mame OSD=retro
		DEBUG=0 NOWERROR=1
	)
	emake "${args[@]}" || die
}
