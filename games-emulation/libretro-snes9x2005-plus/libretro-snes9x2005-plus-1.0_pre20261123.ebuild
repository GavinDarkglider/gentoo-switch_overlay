# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/snes9x2005"
LIBRETRO_COMMIT_SHA="a79dfe9047e7fec58808aefe48ad2bf499c7af11"

inherit libretro-core

DESCRIPTION="snes9x2005_plus libretro core"
HOMEPAGE="https://github.com/libretro/snes9x2005"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/snes9x2005-a79dfe9047e7fec58808aefe48ad2bf499c7af11"

myemakeargs=( USE_BLARGG_APU=\ )

# Upstream builds snes9x2005_libretro.so; install it under this core's name.
src_install() {
	local out="${S}/snes9x2005_plus_libretro.so"
	cp "${S}/snes9x2005_libretro.so" "${out}" || die
	LIBRETRO_CORE_LIB_FILE="${out}" libretro-core_src_install
}
