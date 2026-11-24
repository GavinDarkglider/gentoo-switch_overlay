# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/FBNeo"
LIBRETRO_COMMIT_SHA="c04f5f536a46cd19e5e327d105ed96e9f54d6b6d"

inherit libretro-core

DESCRIPTION="fbneo libretro core"
HOMEPAGE="https://github.com/libretro/FBNeo"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/FBNeo-c04f5f536a46cd19e5e327d105ed96e9f54d6b6d/src/burner/libretro"

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/fbneo_libretro.so" libretro-core_src_install
}

src_prepare() {
	default
	(
		cd "${S}/../../burn" || die
		eapply "${FILESDIR}/fbneo-1.0_pre20261123-001-undef-fopen.patch"
	)
}
