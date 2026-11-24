# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/nxengine-libretro"
LIBRETRO_COMMIT_SHA="fd1c0686f8b4c0aea9b5addbc077e3ad7da23bb7"

inherit libretro-core

DESCRIPTION="nxengine libretro core"
HOMEPAGE="https://github.com/libretro/nxengine-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/nxengine-libretro-fd1c0686f8b4c0aea9b5addbc077e3ad7da23bb7"
