# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-handy"
LIBRETRO_COMMIT_SHA="bc55d462f0b2d6b073ea93dc552ebd73cec60fd1"

inherit libretro-core

DESCRIPTION="handy libretro core"
HOMEPAGE="https://github.com/libretro/libretro-handy"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-handy-bc55d462f0b2d6b073ea93dc552ebd73cec60fd1"
