# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="Clownacy/clownmdemu-libretro"
LIBRETRO_COMMIT_SHA="004044c2cee2b3e3c7452145a40f7b5ea648d8c4"

inherit libretro-core

DESCRIPTION="clownmdemu libretro core"
HOMEPAGE="https://github.com/Clownacy/clownmdemu-libretro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/clownmdemu-libretro-004044c2cee2b3e3c7452145a40f7b5ea648d8c4"
