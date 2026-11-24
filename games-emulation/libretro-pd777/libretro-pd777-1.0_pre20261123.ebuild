# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="mittonk/PD777"
LIBRETRO_COMMIT_SHA="13910d1cf8b139b7560fc61f7a2e0f6c95e407e5"

inherit libretro-core

DESCRIPTION="pd777 libretro core"
HOMEPAGE="https://github.com/mittonk/PD777"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/PD777-13910d1cf8b139b7560fc61f7a2e0f6c95e407e5/source/libretro"

# Upstream makefile: Makefile.libretro
