# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/boom3"

inherit libretro-core

DESCRIPTION="Doom 3 GPL source port for libretro"
HOMEPAGE="https://github.com/libretro/boom3"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/neo"
