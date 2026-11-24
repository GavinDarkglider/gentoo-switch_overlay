# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/SameBoy"
LIBRETRO_COMMIT_SHA="aa158a889a48b538a0302873704a34577c8eb67d"

inherit libretro-core

DESCRIPTION="Gameboy and Gameboy Color emulator written in C"

LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

DEPEND=">=sys-devel/rgbds-0.4.0"

S="${S}/libretro"

src_compile() {
	local myemakeargs=(
		"VERSION=${PV}"
	)
	libretro-core_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so" \
		libretro-core_src_install
}

src_prepare() {
	libretro-core_src_prepare
	eapply -d .. -- "${FILESDIR}/sameboy-0.13.1_pre20200624-001-native-tools.patch"
}
