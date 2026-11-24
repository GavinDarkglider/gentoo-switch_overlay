# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vemulator-libretro"
LIBRETRO_COMMIT_SHA="27a062f6ae532e5028e4fb54f523cc689e78146a"

inherit libretro-core

DESCRIPTION="vemulator libretro core"
HOMEPAGE="https://github.com/libretro/vemulator-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vemulator-libretro-27a062f6ae532e5028e4fb54f523cc689e78146a"

# Upstream makefile: Makefile
