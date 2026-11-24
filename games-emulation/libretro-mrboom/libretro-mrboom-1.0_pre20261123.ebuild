# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mrboom-libretro"
LIBRETRO_COMMIT_SHA="40ac32020b540c4bb418c7d798a990932a65da04"

inherit libretro-core

DESCRIPTION="mrboom libretro core"
HOMEPAGE="https://github.com/libretro/mrboom-libretro"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mrboom-libretro-40ac32020b540c4bb418c7d798a990932a65da04"

# Upstream makefile: Makefile
