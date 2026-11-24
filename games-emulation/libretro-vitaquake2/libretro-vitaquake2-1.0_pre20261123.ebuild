# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vitaquake2"
LIBRETRO_COMMIT_SHA="4b333fe18e8816974f04432af01f87654ae16e21"

inherit libretro-core

DESCRIPTION="vitaquake2 libretro core"
HOMEPAGE="https://github.com/libretro/vitaquake2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vitaquake2-4b333fe18e8816974f04432af01f87654ae16e21"

# Upstream makefile: Makefile
