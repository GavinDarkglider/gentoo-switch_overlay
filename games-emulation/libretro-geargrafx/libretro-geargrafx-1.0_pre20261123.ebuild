# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="drhelius/Geargrafx"
LIBRETRO_COMMIT_SHA="134d8b424443352b839829120e374aee38a7618c"

inherit libretro-core

DESCRIPTION="geargrafx libretro core"
HOMEPAGE="https://github.com/drhelius/Geargrafx"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Geargrafx-134d8b424443352b839829120e374aee38a7618c/platforms/libretro"

# Upstream makefile: Makefile
