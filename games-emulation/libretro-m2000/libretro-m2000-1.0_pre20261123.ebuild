# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="p2000t/M2000"
LIBRETRO_COMMIT_SHA="dd0e04b12526e79ffd4dec27ba8969f36a627e9d"

inherit libretro-core

DESCRIPTION="m2000 libretro core"
HOMEPAGE="https://github.com/p2000t/M2000"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/M2000-dd0e04b12526e79ffd4dec27ba8969f36a627e9d/src/libretro"
