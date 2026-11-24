# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/virtualjaguar-libretro"
LIBRETRO_COMMIT_SHA="4e27ea44da58978d7f02a68a4d6bf36553cc25a2"
inherit libretro-core

DESCRIPTION="Virtual Jaguar libretro port (Atari Jaguar)"
HOMEPAGE="https://github.com/libretro/virtualjaguar-libretro"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
