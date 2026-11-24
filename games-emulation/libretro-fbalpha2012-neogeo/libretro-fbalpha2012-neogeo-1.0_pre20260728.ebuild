# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha2012_neogeo"
LIBRETRO_COMMIT_SHA="e092097037d494c50d17c5144a2758d68538061b"

inherit libretro-core

S="${WORKDIR}/fbalpha2012_neogeo-e092097037d494c50d17c5144a2758d68538061b"

DESCRIPTION="fbalpha2012_neogeo libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha2012_neogeo.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile
