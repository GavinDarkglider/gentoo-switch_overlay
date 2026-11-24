# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/dosbox-svn"
LIBRETRO_COMMIT_SHA="46a3164fc0f1e808ae56143d81698b00fb6b4781"

inherit libretro-core

DESCRIPTION="dosbox_svn libretro core"
HOMEPAGE="https://github.com/libretro/dosbox-svn"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/dosbox-svn-46a3164fc0f1e808ae56143d81698b00fb6b4781/libretro"

myemakeargs=( WITH_FAKE_SDL=1 )
