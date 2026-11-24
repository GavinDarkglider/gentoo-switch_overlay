# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vice-libretro"
LIBRETRO_COMMIT_SHA="76cde0b2cc4e52106618f2cc5d9d1112d9205c89"

inherit libretro-core

DESCRIPTION="vice_xcbm5x0 libretro core"
HOMEPAGE="https://github.com/libretro/vice-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vice-libretro-76cde0b2cc4e52106618f2cc5d9d1112d9205c89"

myemakeargs=( EMUTYPE="xcbm5x0" )

# Upstream makefile: Makefile
