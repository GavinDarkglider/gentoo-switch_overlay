# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/arduous"
LIBRETRO_COMMIT_SHA="831b83e67ad46e8c86b8165649ff81bc6fc6c157"

inherit libretro-core

DESCRIPTION="arduous libretro core"
HOMEPAGE="https://github.com/libretro/arduous"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/arduous-831b83e67ad46e8c86b8165649ff81bc6fc6c157"

myemakeargs=( -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DCMAKE_BUILD_TYPE=Release )
