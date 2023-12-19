# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vitaquake3"
LIBRETRO_COMMIT_SHA="7a633867cf0a35c71701aef6fc9dd9dfab9c33a9"

inherit libretro-core

DESCRIPTION="libretro implementation of VitaQuake3. (Quake III)"
HOMEPAGE="https://github.com/libretro/vitaquake3"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	games-emulation/libretro-info"
