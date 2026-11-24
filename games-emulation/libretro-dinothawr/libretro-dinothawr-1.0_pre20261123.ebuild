# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Dinothawr"
LIBRETRO_COMMIT_SHA="62d3e1ecf85f0feea01cad6809a80303a87e8a28"

inherit libretro-core

DESCRIPTION="dinothawr libretro core"
HOMEPAGE="https://github.com/libretro/Dinothawr"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Dinothawr-62d3e1ecf85f0feea01cad6809a80303a87e8a28"
