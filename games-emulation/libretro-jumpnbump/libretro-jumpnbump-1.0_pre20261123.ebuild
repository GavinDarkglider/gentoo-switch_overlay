# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/jumpnbump-libretro"
LIBRETRO_COMMIT_SHA="2cc840155ce4bf42b2e9e0ef3854b32d534e607e"

inherit libretro-core

DESCRIPTION="jumpnbump libretro core"
HOMEPAGE="https://github.com/libretro/jumpnbump-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/jumpnbump-libretro-2cc840155ce4bf42b2e9e0ef3854b32d534e607e"
