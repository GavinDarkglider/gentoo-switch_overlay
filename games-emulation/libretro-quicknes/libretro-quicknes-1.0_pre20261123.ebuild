# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/QuickNES_Core"
LIBRETRO_COMMIT_SHA="26bb785c9deddb66a17717b21bb4e328f03ade32"

inherit libretro-core

DESCRIPTION="quicknes libretro core"
HOMEPAGE="https://github.com/libretro/QuickNES_Core"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/QuickNES_Core-26bb785c9deddb66a17717b21bb4e328f03ade32"

# Upstream makefile: Makefile
