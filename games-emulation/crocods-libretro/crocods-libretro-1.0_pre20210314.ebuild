# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/libretro-crocods"
LIBRETRO_COMMIT_SHA="86eeccfb68ad6a1cb39ef5b008902f6636d7d194"
inherit libretro-core

DESCRIPTION="Amstrad CPC libretro core"
HOMEPAGE="https://github.com/libretro/libretro-crocods"
KEYWORDS="~arm64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}
