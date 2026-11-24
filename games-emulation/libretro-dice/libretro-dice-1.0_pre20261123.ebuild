# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="mittonk/dice-libretro"
LIBRETRO_COMMIT_SHA="b557d861eb9502799b865a98d794fb81da10ba17"

inherit libretro-core

DESCRIPTION="dice libretro core"
HOMEPAGE="https://github.com/mittonk/dice-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/dice-libretro-b557d861eb9502799b865a98d794fb81da10ba17"
