# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FBNeo"
LIBRETRO_COMMIT_SHA="9558e146597dff8390e8808a87f94b839e5dd791"

inherit libretro-core

DESCRIPTION="Fork of Final Burn Alpha"
HOMEPAGE="https://github.com/libretro/FBNeo"
KEYWORDS="~arm64"

LICENSE="FBA"
SLOT="0"

DEPEND="media-libs/libsdl2
		media-libs/sdl-image"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${WORKDIR}"/FBNeo-${LIBRETRO_COMMIT_SHA}/src/burner/libretro
