# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="d7928c31c778e70ea5a0ac27b2eba089d4138895"

inherit libretro

DESCRIPTION="glsl shaders converted by hand from libretro's common-shaders repo"
HOMEPAGE="https://github.com/libretro/glsl-shaders"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="!<=games-emulation/libretro-common-shaders-1"
DEPEND="${RDEPEND}"

src_install() {
	dodir "${LIBRETRO_DATA_DIR}"/shaders
	# Remove unnecessary git files
	[[ ! ${PV} == "1.0_pre"* ]] && rm -r .git
	cp -R "${S}"/* "${D}/${LIBRETRO_DATA_DIR}"/shaders/
}
