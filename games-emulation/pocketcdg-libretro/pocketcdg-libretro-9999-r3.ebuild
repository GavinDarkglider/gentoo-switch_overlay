# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-pocketcdg"

inherit libretro-core

DESCRIPTION="PocketCDG libretro port."
HOMEPAGE="https://github.com/libretro/libretro-pocketcdg"
KEYWORDS="~arm64"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
