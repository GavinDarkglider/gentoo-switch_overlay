# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/boom3"
LIBRETRO_COMMIT_SHA="e7f8cddf866186cafa95b8a6772e40519eb77ee3"

inherit libretro-core

DESCRIPTION="boom3 libretro core"
HOMEPAGE="https://github.com/libretro/boom3"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/boom3-e7f8cddf866186cafa95b8a6772e40519eb77ee3/neo"

# Upstream makefile: Makefile
