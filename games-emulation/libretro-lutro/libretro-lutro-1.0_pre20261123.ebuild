# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-lutro"
LIBRETRO_COMMIT_SHA="6224157a615b18507bc0b117a3398c7a324cd3e5"

inherit libretro-core

DESCRIPTION="lutro libretro core"
HOMEPAGE="https://github.com/libretro/libretro-lutro"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-lutro-6224157a615b18507bc0b117a3398c7a324cd3e5"

# Upstream makefile: Makefile
