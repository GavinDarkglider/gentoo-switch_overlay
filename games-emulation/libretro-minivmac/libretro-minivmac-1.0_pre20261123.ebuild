# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-minivmac"
LIBRETRO_COMMIT_SHA="babdf7b53d361a7225858b68a8a64efe8b06f5e5"

inherit libretro-core

DESCRIPTION="minivmac libretro core"
HOMEPAGE="https://github.com/libretro/libretro-minivmac"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-minivmac-babdf7b53d361a7225858b68a8a64efe8b06f5e5"

# Upstream makefile: Makefile
