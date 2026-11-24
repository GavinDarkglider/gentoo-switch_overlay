# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="stella-emu/stella"
LIBRETRO_COMMIT_SHA="8dd560091d22f9867cd9192880aa28570ed4d6db"

inherit libretro-core

DESCRIPTION="stella libretro core"
HOMEPAGE="https://github.com/stella-emu/stella"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/stella-8dd560091d22f9867cd9192880aa28570ed4d6db/src/os/libretro"

# Upstream makefile: Makefile
