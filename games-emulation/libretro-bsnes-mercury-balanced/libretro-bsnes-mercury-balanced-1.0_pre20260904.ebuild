# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/bsnes-mercury"
LIBRETRO_COMMIT_SHA="79d7f9de218b6ffa65a80bbdc5828532bc239232"

inherit libretro-core

S="${WORKDIR}/bsnes-mercury-79d7f9de218b6ffa65a80bbdc5828532bc239232"

DESCRIPTION="bsnes_mercury_balanced libretro core"
HOMEPAGE="https://github.com/libretro/bsnes-mercury.git"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

myemakeargs=( compiler=\ )

# Upstream's makefile always builds bsnes_mercury_performance_libretro.so,
# independent of PROFILE. Rename it so both profile ebuilds install cleanly.
src_install() {
	local out="${S}/bsnes_mercury_balanced_libretro.so"
	cp "${S}/bsnes_mercury_performance_libretro.so" "${out}" || die
	LIBRETRO_CORE_LIB_FILE="${out}" libretro-core_src_install
}
