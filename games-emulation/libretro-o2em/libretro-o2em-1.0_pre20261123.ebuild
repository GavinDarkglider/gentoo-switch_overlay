# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-o2em"
LIBRETRO_COMMIT_SHA="679d6fec04963f6e70a7ec217e3d0ebb1fe472fc"

inherit libretro-core

DESCRIPTION="o2em libretro core"
HOMEPAGE="https://github.com/libretro/libretro-o2em"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-o2em-679d6fec04963f6e70a7ec217e3d0ebb1fe472fc"
