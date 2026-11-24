# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="audetto/AppleWin"
LIBRETRO_COMMIT_SHA="6e6df2cb7503af105422a01cfa08a0ebc48486a3"

inherit libretro-core

DESCRIPTION="applewin libretro core"
HOMEPAGE="https://github.com/audetto/AppleWin"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/AppleWin-6e6df2cb7503af105422a01cfa08a0ebc48486a3"

myemakeargs=( -DBUILD_LIBRETRO=ON -DENABLE_NETWORKING=OFF -G Ninja )
