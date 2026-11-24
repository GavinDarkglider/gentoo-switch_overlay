# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2003-libretro"
LIBRETRO_COMMIT_SHA="6db8b53904ec210b09f998b9e2299d650c6d7614"
inherit libretro-core

DESCRIPTION="MAME (0.78) for libretro."
HOMEPAGE="https://github.com/libretro/mame2003-libretro"
KEYWORDS="arm64"

LICENSE="MAME-GPL"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
