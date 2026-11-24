# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/xmil-libretro"
LIBRETRO_COMMIT_SHA="3106aa54ffb244cca4019a6e95dacaa698781bc3"

inherit libretro-core

S="${WORKDIR}/xmil-libretro-3106aa54ffb244cca4019a6e95dacaa698781bc3/libretro"

DESCRIPTION="x1 libretro core"
HOMEPAGE="https://github.com/libretro/xmil-libretro.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile.libretro
