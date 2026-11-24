# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mesen-s"
LIBRETRO_COMMIT_SHA="9e4fdeb9b336470bc96beb8765b2e79c86a2da1e"

inherit libretro-core

S="${WORKDIR}/Mesen-S-9e4fdeb9b336470bc96beb8765b2e79c86a2da1e/Libretro"

DESCRIPTION="mesen-s libretro core"
HOMEPAGE="https://github.com/libretro/mesen-s"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

# Upstream builds mesen-s_libretro.so in Libretro/.
src_install() {
	local out="${S}/mesen_s_libretro.so"
	cp "${S}/mesen-s_libretro.so" "${out}" || die
	LIBRETRO_CORE_LIB_FILE="${out}" libretro-core_src_install
}
