# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-cap32"
LIBRETRO_COMMIT_SHA="06ad0da5d003ab8f2359300ebce4cf31d4c55b6e"

inherit libretro-core

DESCRIPTION="cap32 libretro core"
HOMEPAGE="https://github.com/libretro/libretro-cap32"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-cap32-06ad0da5d003ab8f2359300ebce4cf31d4c55b6e"

# Upstream makefile: Makefile
