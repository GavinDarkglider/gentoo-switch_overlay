# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/SameBoy"
inherit git-r3 libretro-core

DESCRIPTION="libretro implementation of SameBoy (Gameboy / Gameboy Color)"
HOMEPAGE="https://github.com/libretro/SameBoy"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-lang/rgbds"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

S="${S}/libretro"

src_prepare() {
	# Update build path
	sed 's|BootROMs/prebuilt/%_boot.bin|build/bin/BootROMs/%_boot.bin|' -i Makefile
	libretro-core_src_prepare
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		elog ""
		elog "You can optionally place the following files in your 'system_directory' folder:"
		elog "dmg_boot.bin"
		elog "cgb_boot.bin"
		elog ""
	fi
}
