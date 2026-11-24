# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-pcem"
LIBRETRO_COMMIT_SHA="e07923e902dcedcf65a502fb3f14e75b9ded5271"

inherit libretro-core

DESCRIPTION="pcem libretro core"
HOMEPAGE="https://github.com/libretro/libretro-pcem"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-pcem-e07923e902dcedcf65a502fb3f14e75b9ded5271/src"

# Upstream makefile: Makefile.libretro
