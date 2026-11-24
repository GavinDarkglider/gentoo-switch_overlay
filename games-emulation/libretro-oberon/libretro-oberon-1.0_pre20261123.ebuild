# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/oberon-risc-emu"
LIBRETRO_COMMIT_SHA="5be71d885b87b7cd7c635bf330764fcc4f3905fe"

inherit libretro-core

DESCRIPTION="oberon libretro core"
HOMEPAGE="https://github.com/libretro/oberon-risc-emu"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/oberon-risc-emu-5be71d885b87b7cd7c635bf330764fcc4f3905fe"

# Upstream makefile: Makefile.libretro
