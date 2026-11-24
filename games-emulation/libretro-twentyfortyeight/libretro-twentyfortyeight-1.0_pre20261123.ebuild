# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-twentyfortyeight"
LIBRETRO_COMMIT_SHA="39333f7b13dc4daea7c151d9c38d22b961246343"

inherit libretro-core

# Upstream produces 2048_libretro.so.
LIBRETRO_CORE_NAME="2048"

S="${WORKDIR}/libretro-2048-39333f7b13dc4daea7c151d9c38d22b961246343"

DESCRIPTION="2048 libretro core"
HOMEPAGE="https://github.com/libretro/libretro-twentyfortyeight"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="arm64"


# Upstream makefile: Makefile.libretro
