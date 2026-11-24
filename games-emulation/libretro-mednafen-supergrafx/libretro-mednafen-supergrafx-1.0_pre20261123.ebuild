# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-supergrafx-libretro"
LIBRETRO_COMMIT_SHA="9c11dcd213a79d57d2c86313971631af801f2cdc"

inherit libretro-core

DESCRIPTION="mednafen_supergrafx libretro core"
HOMEPAGE="https://github.com/libretro/beetle-supergrafx-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-supergrafx-libretro-9c11dcd213a79d57d2c86313971631af801f2cdc"
