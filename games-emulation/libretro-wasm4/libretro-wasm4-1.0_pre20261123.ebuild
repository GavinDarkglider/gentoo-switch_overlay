# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="aduros/wasm4"
LIBRETRO_COMMIT_SHA="a79314df03c7c859239f81a3958152c09c3aeaf9"

inherit libretro-core

DESCRIPTION="wasm4 libretro core"
HOMEPAGE="https://github.com/aduros/wasm4"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/wasm4-a79314df03c7c859239f81a3958152c09c3aeaf9/runtimes/native"

myemakeargs=( -DCMAKE_BUILD_TYPE=Release -DLIBRETRO=ON -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE )
