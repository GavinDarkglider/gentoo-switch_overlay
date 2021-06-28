# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-3dengine"
LIBRETRO_COMMIT_SHA="4fbe7cb2f90d3c8db994af60085fb2ac93677545"
inherit libretro-core

DESCRIPTION="3D Engine for libretro GL with additional features"
HOMEPAGE="https://github.com/libretro/libretro-3dengine"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
