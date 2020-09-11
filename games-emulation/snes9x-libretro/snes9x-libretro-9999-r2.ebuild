# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="snes9xgit/snes9x"

inherit libretro-core

DESCRIPTION="libretro implementation of SNES9x. (Super Nintendo Entertainment System)"
HOMEPAGE="https://github.com/snes9xgit/snes9x"
KEYWORDS="arm arm64"

LICENSE="snes9x"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

MY_S="${S}"
S="${S}/libretro"

# @ECLASS-VARIABLE: LIBRETRO_CORE_LIB_FILE
# @DESCRIPTION:
# Absolute path of this Libretro core's shared library. Defaults to
# "${S}/${LIBRETRO_CORE_NAME}_libretro.so".
#LIBRETRO_CORE_LIB_FILE="${MY_S}/libretro/${LIBRETRO_CORE_NAME}_libretro.so"

src_install() {
	#insinto "${LIBRETRO_DATA_DIR}"/snes9x_libretro
	#doins "${MY_S}"/docs/snes9x-license.txt
	libretro-core_src_install
}
