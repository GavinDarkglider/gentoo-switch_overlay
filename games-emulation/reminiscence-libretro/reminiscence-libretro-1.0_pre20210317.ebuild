# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/REminiscence"
LIBRETRO_COMMIT_SHA="07b0e37ec0eab1f29f43284d4368ebdb896557e4"

inherit libretro-core

DESCRIPTION="Flashback engine implementation for libretro"
HOMEPAGE="https://github.com/libretro/REminiscence"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
