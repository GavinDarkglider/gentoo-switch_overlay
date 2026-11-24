# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/supafaust"
LIBRETRO_COMMIT_SHA="642d1d1b6684aa7e306a02a89885f3f5456a5157"

inherit libretro-core

DESCRIPTION="mednafen_supafaust libretro core"
HOMEPAGE="https://github.com/libretro/supafaust"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/supafaust-642d1d1b6684aa7e306a02a89885f3f5456a5157"
