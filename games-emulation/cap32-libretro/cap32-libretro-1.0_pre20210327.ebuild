# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-cap32"
LIBRETRO_COMMIT_SHA="408da091504dabe9678b25b7a6c3bbef0bc4c140"
inherit libretro-core

DESCRIPTION="Caprice32 libretro core"
HOMEPAGE="https://github.com/libretro/libretro-cap32"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
