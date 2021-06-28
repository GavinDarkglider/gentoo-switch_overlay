# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FreeIntv"
LIBRETRO_COMMIT_SHA="fcf494ce9578b564f9b466b593697ceb91fea137"
inherit libretro-core

DESCRIPTION="A libretro emulation core for the Mattel Intellivision"
HOMEPAGE="https://github.com/libretro/FreeIntv"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
