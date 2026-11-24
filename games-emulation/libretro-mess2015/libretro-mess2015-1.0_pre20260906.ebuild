# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2015-libretro"
LIBRETRO_COMMIT_SHA="7adbf440d5f554097f58f8c6ebb673adc4320a31"

inherit libretro-core

S="${WORKDIR}/mame2015-libretro-7adbf440d5f554097f58f8c6ebb673adc4320a31"

DESCRIPTION="libretro-mess2015 libretro core"
HOMEPAGE="https://github.com/libretro/mame2015-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
