# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="icculus/mojozork"
LIBRETRO_COMMIT_SHA="ff7e00742a00acec8e175ddefb97520fb270df2d"

inherit libretro-core

DESCRIPTION="mojozork libretro core"
HOMEPAGE="https://github.com/icculus/mojozork"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mojozork-ff7e00742a00acec8e175ddefb97520fb270df2d"

myemakeargs=( -DLIBRETRO=ON )
