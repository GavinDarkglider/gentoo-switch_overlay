# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-fceumm"
LIBRETRO_COMMIT_SHA="fb919fb6fa881aaa6279b765d480220579e5c606"

inherit libretro-core

DESCRIPTION="fceumm libretro core"
HOMEPAGE="https://github.com/libretro/libretro-fceumm"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-fceumm-fb919fb6fa881aaa6279b765d480220579e5c606"

# Upstream makefile: Makefile.libretro
