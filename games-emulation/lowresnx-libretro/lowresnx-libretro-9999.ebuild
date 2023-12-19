# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="timoinutilis/lowres-nx"
inherit git-r3 libretro-core

DESCRIPTION="A simulated retro game console"
HOMEPAGE="https://github.com/timoinutilis/lowres-nx"
KEYWORDS="~arm64"

LICENSE="ZLIB"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S=${S}/platform/LibRetro/
