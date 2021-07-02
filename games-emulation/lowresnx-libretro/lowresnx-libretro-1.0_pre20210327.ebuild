# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="timoinutilis/lowres-nx"
LIBRETRO_COMMIT_SHA="f2b5c1d4ec95290081eb95fd8262bd25bdea31cc"
inherit libretro-core

DESCRIPTION="A simulated retro game console"
HOMEPAGE="https://github.com/timoinutilis/lowres-nx"
KEYWORDS="~arm64 ~x86"

LICENSE="ZLIB"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S=${S}/platform/LibRetro/
