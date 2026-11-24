# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vba-next"
LIBRETRO_COMMIT_SHA="788192f215ad0a1413f1625b40ebba3423fa0ade"

inherit libretro-core

S="${WORKDIR}/vba-next-788192f215ad0a1413f1625b40ebba3423fa0ade"

DESCRIPTION="vba_next libretro core"
HOMEPAGE="https://github.com/libretro/vba-next.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile.libretro
