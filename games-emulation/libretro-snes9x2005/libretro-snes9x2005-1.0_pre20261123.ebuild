# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/snes9x2005"
LIBRETRO_COMMIT_SHA="a79dfe9047e7fec58808aefe48ad2bf499c7af11"

inherit libretro-core

DESCRIPTION="snes9x2005 libretro core"
HOMEPAGE="https://github.com/libretro/snes9x2005"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/snes9x2005-a79dfe9047e7fec58808aefe48ad2bf499c7af11"
