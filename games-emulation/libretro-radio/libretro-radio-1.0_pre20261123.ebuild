# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="fpscan/libretro-radio"
LIBRETRO_COMMIT_SHA="5d7d786ad1d8703a52184ff2ee39712c46ed67c9"

inherit libretro-core

DESCRIPTION="radio libretro core"
HOMEPAGE="https://github.com/fpscan/libretro-radio"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-radio-5d7d786ad1d8703a52184ff2ee39712c46ed67c9"

# Upstream makefile: Makefile
