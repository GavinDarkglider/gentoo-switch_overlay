# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-crocods"
LIBRETRO_COMMIT_SHA="a9c63b29443715ae2add392010fca4eae7f93e67"

inherit libretro-core

DESCRIPTION="crocods libretro core"
HOMEPAGE="https://github.com/libretro/libretro-crocods"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-crocods-a9c63b29443715ae2add392010fca4eae7f93e67"

# Upstream makefile: Makefile
