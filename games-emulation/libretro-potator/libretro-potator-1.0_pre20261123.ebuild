# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/potator"
LIBRETRO_COMMIT_SHA="227c5f6f3ce74d32e9002ce24c1420288559a860"

inherit libretro-core

DESCRIPTION="potator libretro core"
HOMEPAGE="https://github.com/libretro/potator"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/potator-227c5f6f3ce74d32e9002ce24c1420288559a860/platform/libretro"

# Upstream makefile: Makefile
