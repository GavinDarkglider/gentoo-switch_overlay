# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Mu"

inherit libretro-core

DESCRIPTION="A new Palm OS emulator targeting compatibility, speed and accuracy"
HOMEPAGE="https://github.com/libretro/Mu"
KEYWORDS="~arm64"

LICENSE="CC-BY-3.0"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/libretroBuildSystem"
