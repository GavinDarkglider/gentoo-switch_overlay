# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/bsnes2014"
LIBRETRO_COMMIT_SHA="3c1394e042ee444c8248e1b9210e14ea55e836e9"

inherit libretro-core

S="${WORKDIR}/bsnes2014-3c1394e042ee444c8248e1b9210e14ea55e836e9"

DESCRIPTION="bsnes2014_performance libretro core"
HOMEPAGE="https://github.com/libretro/bsnes2014"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
