# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-uzem"
LIBRETRO_COMMIT_SHA="d991ee94547c8294abc1c4cb73d63116aa58b5bc"

inherit libretro-core

DESCRIPTION="uzem libretro core"
HOMEPAGE="https://github.com/libretro/libretro-uzem"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-uzem-d991ee94547c8294abc1c4cb73d63116aa58b5bc"

# Upstream makefile: Makefile.libretro
