# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="celerizer/tamalibretro"
LIBRETRO_COMMIT_SHA="ea8dd612eaab375a04f976149dc693cb5d208b27"

inherit libretro-core

DESCRIPTION="tamalibretro libretro core"
HOMEPAGE="https://github.com/celerizer/tamalibretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/tamalibretro-ea8dd612eaab375a04f976149dc693cb5d208b27"

# Upstream makefile: Makefile
