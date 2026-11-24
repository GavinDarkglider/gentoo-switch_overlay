# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fmsx-libretro"
LIBRETRO_COMMIT_SHA="4de11755ce4f196ac1c8a7bb20bb4eccbc87a7d4"

inherit libretro-core

DESCRIPTION="fmsx libretro core"
HOMEPAGE="https://github.com/libretro/fmsx-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/fmsx-libretro-4de11755ce4f196ac1c8a7bb20bb4eccbc87a7d4"
