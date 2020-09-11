# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/oberon-risc-emu"

inherit libretro-core

DESCRIPTION=" Emulator for the Oberon RISC machine"
HOMEPAGE="https://github.com/libretro/oberon-risc-emu"
KEYWORDS="~arm64"

LICENSE="BSD"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

