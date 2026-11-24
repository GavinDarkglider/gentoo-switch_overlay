# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-meowPC98"
LIBRETRO_COMMIT_SHA="5fdbb2187f6b14ca7bf668dd52b36c820b989995"

inherit libretro-core

S="${WORKDIR}/libretro-meowPC98-5fdbb2187f6b14ca7bf668dd52b36c820b989995/libretro"

DESCRIPTION="libretro-meowpc98 libretro core"
HOMEPAGE="https://github.com/libretro/libretro-meowPC98"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

LIBRETRO_CORE_NAME="nekop2"
