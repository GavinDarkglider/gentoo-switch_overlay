# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="LLeny/holani-retro"
LIBRETRO_COMMIT_SHA="d0d79b4928e3d32695294142784c033ce7aeda9b"

inherit libretro-core

DESCRIPTION="holani libretro core"
HOMEPAGE="https://github.com/LLeny/holani-retro"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/holani-retro-d0d79b4928e3d32695294142784c033ce7aeda9b"
