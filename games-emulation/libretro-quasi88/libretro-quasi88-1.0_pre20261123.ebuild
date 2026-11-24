# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/quasi88-libretro"
LIBRETRO_COMMIT_SHA="94ff9bbd03090699749e2098bb0d1c281ac4ea06"

inherit libretro-core

DESCRIPTION="quasi88 libretro core"
HOMEPAGE="https://github.com/libretro/quasi88-libretro"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/quasi88-libretro-94ff9bbd03090699749e2098bb0d1c281ac4ea06"

# Upstream makefile: Makefile
