# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes2014"
LIBRETRO_COMMIT_SHA="cffc626a7814050320cee9e59ad43fe10bbcb6ab"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"
HOMEPAGE="https://github.com/libretro/bsnes2014"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64 ~x86"
# No tests provided
RESTRICT="test"

S="${WORKDIR}/bsnes2014-${LIBRETRO_COMMIT_SHA}"

src_compile(){
		makeargs="profile=performance"
		libretro-core_src_compile
}
