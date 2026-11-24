# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/OpenLara"
LIBRETRO_COMMIT_SHA="e4ce52edec5a9a6ad22b69d08c687bf070e68876"

inherit libretro-core

DESCRIPTION="openlara libretro core"
HOMEPAGE="https://github.com/libretro/OpenLara"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/OpenLara-e4ce52edec5a9a6ad22b69d08c687bf070e68876/src/platform/libretro"

# Upstream makefile: Makefile
