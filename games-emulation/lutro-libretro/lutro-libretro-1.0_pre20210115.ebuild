# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-lutro"
LIBRETRO_COMMIT_SHA="29a803151dd9dce200a45bc2f0a139493e1d2961"
inherit libretro-core

DESCRIPTION="An experimental lua game framework for libretro following the LOVE API."
HOMEPAGE="https://github.com/libretro/libretro-lutro"
KEYWORDS="~arm64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
