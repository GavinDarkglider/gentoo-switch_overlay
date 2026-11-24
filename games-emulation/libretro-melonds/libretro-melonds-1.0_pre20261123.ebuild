# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/melonDS"
LIBRETRO_COMMIT_SHA="4081e8358e66f1ea11879560be6b813dfeaab75a"

inherit libretro-core

DESCRIPTION="melonds libretro core"
HOMEPAGE="https://github.com/libretro/melonDS"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/melonDS-4081e8358e66f1ea11879560be6b813dfeaab75a"

# Upstream makefile: Makefile
