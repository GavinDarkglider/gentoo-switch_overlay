# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/daphne"

inherit libretro-core

DESCRIPTION="Arcade laserdisc libretro core"
HOMEPAGE="https://github.com/libretro/daphne"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
