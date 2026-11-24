# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/superbroswar-libretro"
LIBRETRO_COMMIT_SHA="7f94e03163e1641ecd2a5703eb9ca7e1312b5e8d"

inherit libretro-core

DESCRIPTION="superbroswar libretro core"
HOMEPAGE="https://github.com/libretro/superbroswar-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/superbroswar-libretro-7f94e03163e1641ecd2a5703eb9ca7e1312b5e8d"

# Upstream makefile: Makefile.libretro
