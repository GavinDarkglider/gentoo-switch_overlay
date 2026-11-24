# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/retro8"
LIBRETRO_COMMIT_SHA="ddc06a142398ee9755894b3f0bb17c8dc428151d"

inherit libretro-core

DESCRIPTION="retro8 libretro core"
HOMEPAGE="https://github.com/libretro/retro8"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/retro8-ddc06a142398ee9755894b3f0bb17c8dc428151d"

# Upstream makefile: Makefile
