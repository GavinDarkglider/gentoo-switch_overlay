# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/dosbox-core"
LIBRETRO_COMMIT_SHA="d38fcb5013e4dca8d119a9786279cf41465757f2"

inherit libretro-core

DESCRIPTION="dosbox_core libretro core"
HOMEPAGE="https://github.com/libretro/dosbox-core"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/dosbox-core-d38fcb5013e4dca8d119a9786279cf41465757f2/libretro"
