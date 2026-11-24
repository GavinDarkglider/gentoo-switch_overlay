# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2003_midway"
LIBRETRO_COMMIT_SHA="fb5fb047d0efd9fdc9d56e50fa377f5e47569d35"

inherit libretro-core

DESCRIPTION="mame2003_midway libretro core"
HOMEPAGE="https://github.com/libretro/mame2003_midway"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2003_midway-fb5fb047d0efd9fdc9d56e50fa377f5e47569d35"
