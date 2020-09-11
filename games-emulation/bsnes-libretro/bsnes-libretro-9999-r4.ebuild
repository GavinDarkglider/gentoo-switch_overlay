# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes-libretro"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"
HOMEPAGE="https://github.com/libretro/bsnes-libretro"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 arm64"
# No tests provided
RESTRICT="test"

BSNES_PROFILES=(accuracy balanced performance)

src_compile() {
for profile in "${BSNES_PROFILES[@]}"; do
	einfo "Building core with profile ${profile}"
	myemakeargs="profile=${profile}" \
        libretro-core_src_compile
done
}

src_install() {
for profile in "${BSNES_PROFILES[@]}"; do
		LIBRETRO_CORE_LIB_FILE="${S}/out/bsnes2014_${profile}_libretro.so" \
			libretro-core_src_install
done
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}
