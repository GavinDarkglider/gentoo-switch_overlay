# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/geolith-libretro"
LIBRETRO_COMMIT_SHA="2dc88e3fa72ff404213a65d6eb5bb33baa687f73"

inherit libretro-core

DESCRIPTION="geolith libretro core"
HOMEPAGE="https://github.com/libretro/geolith-libretro"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/geolith-libretro-2dc88e3fa72ff404213a65d6eb5bb33baa687f73/libretro"
