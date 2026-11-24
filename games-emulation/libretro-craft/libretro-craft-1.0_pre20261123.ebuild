# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Craft"
LIBRETRO_COMMIT_SHA="f30e7b4b1d1406c750a504583adf0cc88449a699"

inherit libretro-core

DESCRIPTION="craft libretro core"
HOMEPAGE="https://github.com/libretro/Craft"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Craft-f30e7b4b1d1406c750a504583adf0cc88449a699"

# Upstream makefile: Makefile.libretro
