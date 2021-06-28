# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Mu"
LIBRETRO_COMMIT_SHA="5795ade53199e9d0dd5e4331282c7d14a3899074"

inherit libretro-core

DESCRIPTION="A new Palm OS emulator targeting compatibility, speed and accuracy"
HOMEPAGE="https://github.com/libretro/Mu"
KEYWORDS="~arm64 ~x86"

LICENSE="CC-BY-3.0"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/libretroBuildSystem"
