# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/dosbox-pure"
LIBRETRO_COMMIT_SHA="e39497e7c2a32c67c26e6598dd14f6d58c384bfd"

inherit libretro-core toolchain-funcs

DESCRIPTION="DOS emulator, built for RetroArch/Libretro aiming for simplicity and ease of use"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}"

#S="${S}/desmume/src/frontend/libretro"

myemakeargs=( "STRIP=$(tc-getSTRIP)" )
