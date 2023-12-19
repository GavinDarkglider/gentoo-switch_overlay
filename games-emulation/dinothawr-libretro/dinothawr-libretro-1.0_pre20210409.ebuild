# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Dinothawr"
LIBRETRO_COMMIT_SHA="90264f4de875407212ada474761097de7a45fa53"
inherit libretro-core

DESCRIPTION="Dinothawr is a block pushing puzzle game on slippery surfaces."
HOMEPAGE="https://github.com/libretro/Dinothawr"
KEYWORDS="~arm64"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
