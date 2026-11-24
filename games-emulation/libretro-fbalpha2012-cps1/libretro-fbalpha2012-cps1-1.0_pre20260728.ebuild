# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha2012_cps1"
LIBRETRO_COMMIT_SHA="5542c1848ef81e92db311193b01dc349bc29d7cc"

inherit libretro-core

S="${WORKDIR}/fbalpha2012_cps1-5542c1848ef81e92db311193b01dc349bc29d7cc"

DESCRIPTION="fbalpha2012_cps1 libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha2012_cps1.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: makefile.libretro
