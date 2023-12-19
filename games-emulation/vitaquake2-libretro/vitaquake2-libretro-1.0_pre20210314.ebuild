# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vitaquake2"
LIBRETRO_COMMIT_SHA="0fc99af0936735198e1788fb943498be78a9e740"

inherit libretro-core

DESCRIPTION="libretro implementation of VitaQuake2. (Quake II)"
HOMEPAGE="https://github.com/libretro/vitaquake2"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

