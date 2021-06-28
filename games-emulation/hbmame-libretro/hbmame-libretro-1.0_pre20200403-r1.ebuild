# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/hbmame-libretro"
LIBRETRO_COMMIT_SHA="e72c7cfe6184bf57714377cd4c5d6efc422806e3"

inherit libretro-core

DESCRIPTION="Emulator of homebrew and hacked games for arcade hardware"
HOMEPAGE="https://github.com/libretro/hbmame-libretro"
KEYWORDS="~arm64 ~x86"

LICENSE="MAME"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

#src_configure() {
#		emake -f Makefile.libretro PTR64=1
#}
