# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fixGB"
LIBRETRO_COMMIT_SHA="c7865087b8c8126b8bc60fddb75b20efad992458"

inherit libretro-core

DESCRIPTION="fixgb libretro core"
HOMEPAGE="https://github.com/libretro/fixGB"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/fixGB-c7865087b8c8126b8bc60fddb75b20efad992458/libretro"
