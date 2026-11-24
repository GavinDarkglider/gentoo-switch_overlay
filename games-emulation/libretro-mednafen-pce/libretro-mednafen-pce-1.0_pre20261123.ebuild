# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-pce-libretro"
LIBRETRO_COMMIT_SHA="974fe085a9842be2069afc95beaf469a90e9ae44"

inherit libretro-core

DESCRIPTION="mednafen_pce libretro core"
HOMEPAGE="https://github.com/libretro/beetle-pce-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-pce-libretro-974fe085a9842be2069afc95beaf469a90e9ae44"
