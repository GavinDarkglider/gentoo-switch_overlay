# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-saturn-libretro"
LIBRETRO_COMMIT_SHA="7126d65b83b65b4316736434ecca2f5ff4f1a3dd"

inherit libretro-core

DESCRIPTION="Mednafen Saturn"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="
	virtual/opengl
"
DEPEND="${RDEPEND}"

#src_install() {
#	LIBRETRO_CORE_LIB_FILE="${S}/mednafen_saturn_libretro.so" \
#		libretro-core_src_install
#}
