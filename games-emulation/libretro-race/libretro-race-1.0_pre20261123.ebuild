# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/RACE"
LIBRETRO_COMMIT_SHA="c660d9ab5aafb47aefff90182ca90d319ad9b077"

inherit libretro-core

DESCRIPTION="race libretro core"
HOMEPAGE="https://github.com/libretro/RACE"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/RACE-c660d9ab5aafb47aefff90182ca90d319ad9b077"
