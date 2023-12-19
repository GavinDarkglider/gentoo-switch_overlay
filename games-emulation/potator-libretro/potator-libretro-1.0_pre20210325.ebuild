# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/potator"
LIBRETRO_COMMIT_SHA="2873c42f28012992c1132fd083787f5b76b99418"
inherit libretro-core

DESCRIPTION="A Watara Supervision Emulator based on Normmatt version"
HOMEPAGE="https://github.com/libretro/potator"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S=${S}/platform/libretro
