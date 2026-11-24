# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2009-libretro"
LIBRETRO_COMMIT_SHA="29b38f53013e02af7840fdca9bdaba9710e8b232"

inherit libretro-core

DESCRIPTION="mame2009 libretro core"
HOMEPAGE="https://github.com/libretro/mame2009-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2009-libretro-29b38f53013e02af7840fdca9bdaba9710e8b232"
