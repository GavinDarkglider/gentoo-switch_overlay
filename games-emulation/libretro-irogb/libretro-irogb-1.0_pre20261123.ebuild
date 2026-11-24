# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="AlexSutila/IroGB"
LIBRETRO_COMMIT_SHA="430917297bbe5d5fdcbcc29aee7e03fc5b670fd9"

inherit libretro-core

DESCRIPTION="irogb libretro core"
HOMEPAGE="https://github.com/AlexSutila/IroGB"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/IroGB-430917297bbe5d5fdcbcc29aee7e03fc5b670fd9"

myemakeargs=( -DBUILD_LIBRETRO=ON -DNO_CORE_FILESYSTEM=ON )
