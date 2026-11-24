# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/gong"
LIBRETRO_COMMIT_SHA="69ef0b69dc542af4c1cf2efcc451dd6c378281b6"

inherit libretro-core

DESCRIPTION="gong libretro core"
HOMEPAGE="https://github.com/libretro/gong"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/gong-69ef0b69dc542af4c1cf2efcc451dd6c378281b6"

# Upstream makefile: Makefile.libretro
