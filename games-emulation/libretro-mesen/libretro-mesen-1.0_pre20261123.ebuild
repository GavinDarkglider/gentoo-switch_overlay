# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Mesen"
LIBRETRO_COMMIT_SHA="0102910c39ad1a62bc3f784466f3f67ca9eae335"

inherit libretro-core

DESCRIPTION="mesen libretro core"
HOMEPAGE="https://github.com/libretro/Mesen"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Mesen-0102910c39ad1a62bc3f784466f3f67ca9eae335/Libretro"
