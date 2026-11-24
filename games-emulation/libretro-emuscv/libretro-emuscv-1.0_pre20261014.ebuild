# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="MaaaX-EmuSCV/libretro-emuscv"
LIBRETRO_COMMIT_SHA="33900ce24f45c429b533fdae7844e04d64a9a1b9"

inherit libretro-core

S="${WORKDIR}/libretro-emuscv-33900ce24f45c429b533fdae7844e04d64a9a1b9"

DESCRIPTION="emuscv libretro core"
HOMEPAGE="https://gitlab.com/MaaaX-EmuSCV/libretro-emuscv"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
