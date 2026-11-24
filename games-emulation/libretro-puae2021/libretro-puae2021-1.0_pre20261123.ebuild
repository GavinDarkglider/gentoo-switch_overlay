# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-uae"
LIBRETRO_COMMIT_SHA="d366f77c60e5a5f059f129cc3773d3048306083b"

inherit libretro-core

DESCRIPTION="puae2021 libretro core"
HOMEPAGE="https://github.com/libretro/libretro-uae"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-uae-d366f77c60e5a5f059f129cc3773d3048306083b"

# Upstream makefile: Makefile

# Upstream builds puae_libretro.so even though this core is named puae2021.
src_install() {
	local out="${S}/puae2021_libretro.so"
	cp "${S}/puae_libretro.so" "${out}" || die
	LIBRETRO_CORE_LIB_FILE="${out}" libretro-core_src_install
}
