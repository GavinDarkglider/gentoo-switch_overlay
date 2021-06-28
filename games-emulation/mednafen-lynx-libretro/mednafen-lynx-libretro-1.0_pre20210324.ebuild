# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-lynx-libretro"
LIBRETRO_COMMIT_SHA="26cb625d1f1c27137ce8069d155231f5a5c68bda"

inherit libretro-core

DESCRIPTION="libretro implementation of Mednafen Lynx. (Atari Lynx)"
HOMEPAGE="https://github.com/libretro/beetle-lynx-libretro"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
