# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/PokeMini"
LIBRETRO_COMMIT_SHA="132111b76343559860532a1ccc094f93f1ed5650"

inherit libretro-core

DESCRIPTION="pokemini libretro core"
HOMEPAGE="https://github.com/libretro/PokeMini"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/PokeMini-132111b76343559860532a1ccc094f93f1ed5650"

# Upstream makefile: Makefile
