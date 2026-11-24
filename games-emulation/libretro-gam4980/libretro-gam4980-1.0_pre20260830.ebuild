# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="iyzsong/gam4980"
LIBRETRO_COMMIT_SHA="32c531d3e7159081afd8dee72e8266153821095d"

inherit libretro-core

S="${WORKDIR}/gam4980"

DESCRIPTION="gam4980 libretro core"
HOMEPAGE="https://codeberg.org/iyzsong/gam4980.git"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

myemakeargs=( -DCMAKE_BUILD_TYPE=Release )
