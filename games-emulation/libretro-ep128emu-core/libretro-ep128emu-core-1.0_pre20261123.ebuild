# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/ep128emu-core"
LIBRETRO_COMMIT_SHA="6af5d03de220e6effcd0ffcd99e0fb8e8c77cc9e"

inherit libretro-core

DESCRIPTION="ep128emu_core libretro core"
HOMEPAGE="https://github.com/libretro/ep128emu-core"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/ep128emu-core-6af5d03de220e6effcd0ffcd99e0fb8e8c77cc9e"
