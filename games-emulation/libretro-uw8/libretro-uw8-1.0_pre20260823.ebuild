# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/uw8-libretro"
LIBRETRO_COMMIT_SHA="1a64f4bde9662cb3dc04214d2b9f8ead19c85f0a"

inherit libretro-core

S="${WORKDIR}/uw8-libretro-1a64f4bde9662cb3dc04214d2b9f8ead19c85f0a"

DESCRIPTION="uw8 libretro core"
HOMEPAGE="https://github.com/libretro/uw8-libretro.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile
