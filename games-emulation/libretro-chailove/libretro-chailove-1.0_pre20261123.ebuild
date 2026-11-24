# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/ChaiLove"
LIBRETRO_COMMIT_SHA="e388ddc312e73ea922b47b23b0d9c01772eb74b1"

inherit libretro-core

DESCRIPTION="chailove libretro core"
HOMEPAGE="https://github.com/libretro/ChaiLove"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-chailove-e388ddc312e73ea922b47b23b0d9c01772eb74b1"

# Upstream makefile: Makefile

# The eclass automatically passes -f Makefile.libretro, but this core defines
# its build targets in Makefile (which includes Makefile.libretro).
src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) -f Makefile \
		$(usex debug "DEBUG=1" "") "${myemakeargs[@]}"
}
