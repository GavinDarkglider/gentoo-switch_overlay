# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/meteor-libretro"
LIBRETRO_COMMIT_SHA="9ea6c358eae6acd1a346647d96b832ccaffad0aa"

inherit libretro-core

DESCRIPTION="meteor libretro core"
HOMEPAGE="https://github.com/libretro/meteor-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/meteor-libretro-9ea6c358eae6acd1a346647d96b832ccaffad0aa/libretro"
