# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="SourMesen/Mesen"

inherit libretro-core

DESCRIPTION="Libretro implementation of Mesen. (Nintendo Entertainment System)"
HOMEPAGE="https://github.com/SourMesen/Mesen"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/Libretro"
