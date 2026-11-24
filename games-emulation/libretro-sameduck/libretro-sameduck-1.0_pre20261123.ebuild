# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/sameduck"
LIBRETRO_COMMIT_SHA="040e19c379f00dae10afe0eb0c1b2b019b985bbe"

inherit libretro-core

DESCRIPTION="sameduck libretro core"
HOMEPAGE="https://github.com/libretro/sameduck"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/sameduck-040e19c379f00dae10afe0eb0c1b2b019b985bbe/libretro"

# Upstream makefile: Makefile
