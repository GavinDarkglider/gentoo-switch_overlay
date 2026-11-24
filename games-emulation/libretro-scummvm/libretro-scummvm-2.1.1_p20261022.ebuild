# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/scummvm"
LIBRETRO_COMMIT_SHA="e0ddc60bfabb1efdf1e135006c8914ca59d0596c"

inherit libretro-core

DESCRIPTION="Interpreter for point-and-click adventure games as a libretro core."

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

MY_S="${WORKDIR}/scummvm-${LIBRETRO_COMMIT_SHA}"
S="${MY_S}/backends/platform/libretro"

src_prepare() {
	eapply -d "${MY_S}" -- "${FILESDIR}/scummvm-2.1.1_p20261022-001-gnu-source.patch"
	libretro-core_src_prepare
}
