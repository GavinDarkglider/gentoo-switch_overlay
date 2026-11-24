# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/ecwolf"
LIBRETRO_COMMIT_SHA="0cccd9a85d7ffa33fb695691a8a5db246606518c"

inherit libretro-core

DESCRIPTION="ecwolf libretro core"
HOMEPAGE="https://github.com/libretro/ecwolf"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/ecwolf-0cccd9a85d7ffa33fb695691a8a5db246606518c/src/libretro"

# Upstream makefile: Makefile
