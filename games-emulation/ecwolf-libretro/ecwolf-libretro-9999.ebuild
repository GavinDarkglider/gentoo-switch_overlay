# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/ecwolf"

inherit libretro-core

DESCRIPTION="Updated engine for wolfenstein 3D and compatibles"
HOMEPAGE="https://github.com/libretro/ecwolf"
KEYWORDS="~arm64"

LICENSE="GPL-2 MAME ID"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/src/libretro"
