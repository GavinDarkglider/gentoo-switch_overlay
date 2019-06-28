# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libretro

DESCRIPTION="Collection of overlay files for use with libretro frontends."
HOMEPAGE="https://github.com/libretro/common-overlays"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodir "${LIBRETRO_DATA_DIR}"/overlays
	cp -R "${S}"/* "${D}${LIBRETRO_DATA_DIR}"/overlays
}
