# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-remotejoy"
LIBRETRO_COMMIT_SHA="745b97ca8d2d825d0bfde4bb321d1bf7b49fd91d"

inherit libretro-core

DESCRIPTION="remotejoy libretro core"
HOMEPAGE="https://github.com/libretro/libretro-remotejoy"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-remotejoy-745b97ca8d2d825d0bfde4bb321d1bf7b49fd91d"

# Upstream makefile: Makefile
