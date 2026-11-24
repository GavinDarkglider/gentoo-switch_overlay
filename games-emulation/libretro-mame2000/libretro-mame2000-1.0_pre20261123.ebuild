# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2000-libretro"
LIBRETRO_COMMIT_SHA="181b42e5da0d2f0c7a2e59244f23633ed594de2e"

inherit libretro-core

DESCRIPTION="mame2000 libretro core"
HOMEPAGE="https://github.com/libretro/mame2000-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2000-libretro-181b42e5da0d2f0c7a2e59244f23633ed594de2e"
