# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/px68k-libretro"
LIBRETRO_COMMIT_SHA="5340a529c0230669cb434ea8cef29f139e39b40c"

inherit libretro-core

DESCRIPTION="libretro implementation of PX68K. (Sharp X68000)"
HOMEPAGE="https://github.com/libretro/px68k-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "This core needs the following files in the \"'system_directory'/keropi\" directory"
		ewarn "iplrom.dat (X68000 BIOS)"
		ewarn "cgrom.dat (X68000 BIOS 2)"
		ewarn ""
		elog ""
		elog "Optional:"
		elog "iplrom30.dat (X68000 BIOS 3)"
		elog ""
		elog "They can be legally acquired from:"
		elog "https://www.gamestone.co.uk/gradiushomeworld/guides_emulators_x68_winx68khighspeed_guide.php"
		elog ""
	fi
}
