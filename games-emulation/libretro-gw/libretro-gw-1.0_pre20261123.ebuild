# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/gw-libretro"
LIBRETRO_COMMIT_SHA="91d599b951e7bfe7e040347f58667cba20074adc"

inherit libretro-core

DESCRIPTION="gw libretro core"
HOMEPAGE="https://github.com/libretro/gw-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/gw-libretro-91d599b951e7bfe7e040347f58667cba20074adc"

# Upstream makefile: Makefile.libretro
