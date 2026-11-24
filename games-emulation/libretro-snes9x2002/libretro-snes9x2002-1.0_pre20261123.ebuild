# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/snes9x2002"
LIBRETRO_COMMIT_SHA="6ffbf9ef4f0063e1f1b78a40d10c50fc52f2524c"

inherit libretro-core

DESCRIPTION="snes9x2002 libretro core"
HOMEPAGE="https://github.com/libretro/snes9x2002"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/snes9x2002-6ffbf9ef4f0063e1f1b78a40d10c50fc52f2524c"
