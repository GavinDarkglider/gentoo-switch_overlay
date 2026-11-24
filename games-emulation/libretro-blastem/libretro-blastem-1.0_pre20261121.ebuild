# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/blastem"
# Newest libretro branch commit; older snapshots were x86-only.
LIBRETRO_COMMIT_SHA="aa11275a99b3ea0ee477fed2844bb7d9f9faf3f6"
inherit libretro-core

DESCRIPTION="BlastEm libretro port (Sega Genesis / Mega Drive)"
HOMEPAGE="https://github.com/libretro/blastem"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64"

DEPEND="virtual/zlib"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

myemakeargs=( "HOST_ZLIB=1" )
