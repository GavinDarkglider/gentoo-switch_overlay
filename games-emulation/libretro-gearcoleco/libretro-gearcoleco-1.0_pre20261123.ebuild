# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="drhelius/Gearcoleco"
LIBRETRO_COMMIT_SHA="e8d9ed7ab1fc7f8003b3c9ae0e5bfe7c782cf761"

inherit libretro-core

DESCRIPTION="gearcoleco libretro core"
HOMEPAGE="https://github.com/drhelius/Gearcoleco"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Gearcoleco-e8d9ed7ab1fc7f8003b3c9ae0e5bfe7c782cf761/platforms/libretro"
