# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/gpsp"
LIBRETRO_COMMIT_SHA="5819380c2ffb0900219d700a382ee68c464ebb99"

inherit libretro-core

DESCRIPTION="gpsp libretro core"
HOMEPAGE="https://github.com/libretro/gpsp"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/gpsp-5819380c2ffb0900219d700a382ee68c464ebb99"

myemakeargs=( platform=arm64 )
