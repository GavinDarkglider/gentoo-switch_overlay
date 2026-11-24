# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="RPCS3/rpcs3"
LIBRETRO_COMMIT_SHA="0ba0a70b549ff1377f1a93a22c8703a129d123b8"

inherit libretro-core

S="${WORKDIR}/rpcs3-0ba0a70b549ff1377f1a93a22c8703a129d123b8"

DESCRIPTION="rpcs3 libretro core"
HOMEPAGE="https://github.com/RPCS3/rpcs3"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
