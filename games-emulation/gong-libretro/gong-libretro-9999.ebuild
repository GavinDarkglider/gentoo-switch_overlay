# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/gong"
LIBRETRO_COMMIT_SHA="c33d6f32fc76b642297e1b827edbd8434fec027f"

inherit libretro-core

DESCRIPTION="Pong implementation for libretro"
HOMEPAGE="https://github.com/libretro/gong"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
