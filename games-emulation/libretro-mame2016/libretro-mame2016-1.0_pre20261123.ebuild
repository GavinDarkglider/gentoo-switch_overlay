# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2016-libretro"
LIBRETRO_COMMIT_SHA="ae07c2f88ff2482ba9f50ffc8c9e7e6fbfe97d0a"

inherit libretro-core

DESCRIPTION="mame2016 libretro core"
HOMEPAGE="https://github.com/libretro/mame2016-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2016-libretro-ae07c2f88ff2482ba9f50ffc8c9e7e6fbfe97d0a"
