# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="SourMesen/Mesen"
LIBRETRO_COMMIT_SHA="f3a18bed018fa853627e0e15d02a3f2ba4960222"

inherit libretro-core

DESCRIPTION="libretro implementation of Mesen. (Nintendo Entertainment System)"
HOMEPAGE="https://github.com/SourMesen/Mesen"
KEYWORDS="amd64 x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/Libretro"
