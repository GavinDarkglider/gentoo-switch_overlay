# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/smsplus-gx"
LIBRETRO_COMMIT_SHA="53f93019a80cde04c2c50fec25978219fe4650c5"
inherit libretro-core

DESCRIPTION="Improved port of SMSPlus-GX by gameblabla for libretro"
HOMEPAGE="https://github.com/libretro/smsplus-gx"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
