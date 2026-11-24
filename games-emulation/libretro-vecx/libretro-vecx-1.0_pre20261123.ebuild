# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-vecx"
LIBRETRO_COMMIT_SHA="dccff5402a16d1ea7c112095a8e42632bf149506"

inherit libretro-core

DESCRIPTION="vecx libretro core"
HOMEPAGE="https://github.com/libretro/libretro-vecx"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-vecx-dccff5402a16d1ea7c112095a8e42632bf149506"

# Upstream makefile: Makefile.libretro
