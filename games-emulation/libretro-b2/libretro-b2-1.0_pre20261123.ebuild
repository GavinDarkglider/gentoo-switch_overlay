# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="zoltanvb/b2-libretro"
LIBRETRO_COMMIT_SHA="9793f6a8040c416d147003cada29363b955b54e7"

inherit libretro-core

DESCRIPTION="b2 libretro core"
HOMEPAGE="https://github.com/zoltanvb/b2-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/b2-libretro-9793f6a8040c416d147003cada29363b955b54e7/src/libretro"
