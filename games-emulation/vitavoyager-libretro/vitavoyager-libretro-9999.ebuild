# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vitavoyager"

inherit libretro-core

DESCRIPTION="lilium-voyager (Star Trek Voyager: Elite Force Holomatch mp) for libretro"
HOMEPAGE="https://github.com/libretro/vitavoyager"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	games-emulation/libretro-info"
