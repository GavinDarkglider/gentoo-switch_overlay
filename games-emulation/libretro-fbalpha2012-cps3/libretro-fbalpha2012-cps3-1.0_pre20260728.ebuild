# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha2012_cps3"
LIBRETRO_COMMIT_SHA="57f8015c2e0cdebcf42d3add2c314bb7448f9421"

inherit libretro-core

S="${WORKDIR}/fbalpha2012_cps3-57f8015c2e0cdebcf42d3add2c314bb7448f9421/svn-current/trunk"

DESCRIPTION="fbalpha2012_cps3 libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha2012_cps3.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: makefile.libretro
