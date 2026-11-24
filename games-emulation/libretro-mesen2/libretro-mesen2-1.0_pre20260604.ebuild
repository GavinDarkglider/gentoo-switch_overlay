# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="SourMesen/Mesen2"
LIBRETRO_COMMIT_SHA="b9fa69ddc6d0a331fb103fdb5eef6904305703c2"

inherit libretro-core

S="${WORKDIR}/Mesen2-b9fa69ddc6d0a331fb103fdb5eef6904305703c2"

DESCRIPTION="mesen2 libretro core"
HOMEPAGE="https://github.com/SourMesen/Mesen2"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
