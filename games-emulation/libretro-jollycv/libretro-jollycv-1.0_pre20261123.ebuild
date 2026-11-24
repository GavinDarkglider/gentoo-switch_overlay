# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/jollycv"
LIBRETRO_COMMIT_SHA="2790d59c7194d29e83f8603ffd7e9da17f11575e"

inherit libretro-core

DESCRIPTION="jollycv libretro core"
HOMEPAGE="https://github.com/libretro/jollycv"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/jollycv-2790d59c7194d29e83f8603ffd7e9da17f11575e/libretro"
