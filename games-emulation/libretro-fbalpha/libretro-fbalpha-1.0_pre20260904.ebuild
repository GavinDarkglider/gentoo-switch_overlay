# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha"
LIBRETRO_COMMIT_SHA="b25b724ba2046f00f6615a6ffd4eed85a7e367a0"

inherit libretro-core

LIBRETRO_CORE_NAME="fbalpha"

S="${WORKDIR}/fbalpha-b25b724ba2046f00f6615a6ffd4eed85a7e367a0"

DESCRIPTION="libretro-fbalpha libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
