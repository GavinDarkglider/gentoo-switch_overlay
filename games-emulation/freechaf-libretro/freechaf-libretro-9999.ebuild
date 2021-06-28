# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FreeChaF"

inherit libretro-core

DESCRIPTION="Libretro emulation core for the Fairchild ChannelF / Video Entertainment System"
HOMEPAGE="https://github.com/libretro/FreeChaF"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
