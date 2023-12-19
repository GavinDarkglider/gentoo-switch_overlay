# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-gba-libretro"
LIBRETRO_COMMIT_SHA="e07b5cb69bcd28177822960cb2c12fce4c94aa8f"

inherit libretro-core

DESCRIPTION="libretro implementation of Mednafen VBA/GBA. (Game Boy Advance)"
HOMEPAGE="https://github.com/libretro/beetle-gba-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		elog ""
		elog "You should put the following optional files in your 'system_directory' folder:"
		elog "gba_bios.bin (GBA BIOS)"
		elog ""
		ewarn ""
	fi
}
