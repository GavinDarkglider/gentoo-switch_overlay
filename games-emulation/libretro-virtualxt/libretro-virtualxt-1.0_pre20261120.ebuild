# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="virtualxt/virtualxt"
LIBRETRO_COMMIT_SHA="c6dbc6465f0ff19fcc3788c008098e30f77f270b"

inherit libretro-core

S="${WORKDIR}/virtualxt/tools/package/libretro"

DESCRIPTION="virtualxt libretro core"
HOMEPAGE="https://codeberg.org/virtualxt/virtualxt.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
