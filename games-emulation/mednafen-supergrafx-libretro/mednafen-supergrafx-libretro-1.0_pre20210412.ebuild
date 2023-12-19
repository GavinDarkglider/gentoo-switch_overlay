# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-supergrafx-libretro"
LIBRETRO_COMMIT_SHA="7a84c5e3b9e0dc44266d3442130296888f3c573a"
inherit libretro-core

DESCRIPTION="libretro implementation of Mednafen Supergrafx. (SuperGrafx TG-16)"
HOMEPAGE="https://github.com/libretro/beetle-supergrafx-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
