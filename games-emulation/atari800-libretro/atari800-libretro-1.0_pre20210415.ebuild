# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-atari800"
LIBRETRO_COMMIT_SHA="86c87b543f2076e7edcff5d7f5031845ca4ffb96"
inherit libretro-core

DESCRIPTION="Free and portable Atari 8-bit computer and 5200 console emulator"
HOMEPAGE="https://github.com/libretro/libretro-atari800"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
