# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/bk-emulator"
LIBRETRO_COMMIT_SHA="92042a753289cedf05e7e6bd8e75849f83e48966"

inherit libretro-core

DESCRIPTION="bk libretro core"
HOMEPAGE="https://github.com/libretro/bk-emulator"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/bk-emulator-92042a753289cedf05e7e6bd8e75849f83e48966"

# Upstream makefile: Makefile.libretro
