# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/oberon-risc-emu"
LIBRETRO_COMMIT_SHA="0d33a1fa5e42f6bab433a67f4b96505ef7699c19"

inherit libretro-core

DESCRIPTION="Emulator for the Oberon RISC machine"
HOMEPAGE="https://github.com/libretro/oberon-risc-emu"
KEYWORDS="~arm64"

LICENSE="BSD"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
