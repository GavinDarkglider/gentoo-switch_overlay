# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/gambatte-libretro"
LIBRETRO_COMMIT_SHA="138bcbbf311300a271896bf93a76370c72cab339"
inherit libretro-core

DESCRIPTION="Gambatte libretro port (Nintendo Game Boy / Game Boy Color)"
HOMEPAGE="https://github.com/libretro/gambatte-libretro"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="games-emulation/libretro-info"
