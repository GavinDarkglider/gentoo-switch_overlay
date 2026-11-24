# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="RobLoach/libretro-jgenesis"
LIBRETRO_COMMIT_SHA="3700c2c6fcb92fa5820a3bb018bd0cf668f9f730"

inherit libretro-core

DESCRIPTION="jgenesis libretro core"
HOMEPAGE="https://github.com/RobLoach/libretro-jgenesis"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-jgenesis-3700c2c6fcb92fa5820a3bb018bd0cf668f9f730"

# Upstream makefile: Makefile.libretro
