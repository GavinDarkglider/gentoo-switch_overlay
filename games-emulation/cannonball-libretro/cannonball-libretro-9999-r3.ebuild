# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/cannonball"
inherit libretro-core

DESCRIPTION="An Enhanced OutRun Engine."
HOMEPAGE="https://github.com/libretro/cannonball"

KEYWORDS="~arm64 ~x86"

LICENSE="cannonball"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
