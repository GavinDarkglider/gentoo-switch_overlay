# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-3dengine"
LIBRETRO_COMMIT_SHA="efa2bf6f32f930721fe9ae2361d7ec858077c483"

inherit libretro-core

DESCRIPTION="3dengine libretro core"
HOMEPAGE="https://github.com/libretro/libretro-3dengine"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-3dengine-efa2bf6f32f930721fe9ae2361d7ec858077c483"
