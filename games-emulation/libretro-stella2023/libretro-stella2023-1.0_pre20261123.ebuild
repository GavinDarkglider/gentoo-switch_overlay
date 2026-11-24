# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/stella2023"
LIBRETRO_COMMIT_SHA="ba52c43b9eda950eb0c0eec69cda9b17dee8c39b"

inherit libretro-core

DESCRIPTION="stella2023 libretro core"
HOMEPAGE="https://github.com/libretro/stella2023"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/stella2023-ba52c43b9eda950eb0c0eec69cda9b17dee8c39b/src/os/libretro"

# Upstream makefile: Makefile
