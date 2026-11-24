# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/bsnes-libretro-cplusplus98"
LIBRETRO_COMMIT_SHA="baec09aa4796b7575aba1c1ae7335f493c2216af"

inherit libretro-core

S="${WORKDIR}/bsnes-libretro-cplusplus98-baec09aa4796b7575aba1c1ae7335f493c2216af"

DESCRIPTION="bsnes_cplusplus98 libretro core"
HOMEPAGE="https://github.com/libretro/bsnes-libretro-cplusplus98.git"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
