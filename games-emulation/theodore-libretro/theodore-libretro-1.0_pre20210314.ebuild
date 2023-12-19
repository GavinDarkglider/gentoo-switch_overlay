# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="Zlika/theodore"
LIBRETRO_COMMIT_SHA="9f1afc67a549b56a8eb619fd935a86cc150b8a50"

inherit libretro-core

DESCRIPTION="Libretro core for Thomson TO8/TO8D/TO9/TO9+ emulation."
HOMEPAGE="https://github.com/Zlika/theodore"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
