# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/pcsx1-libretro"
LIBRETRO_COMMIT_SHA="35dabb85ff3af6825820f54090d344945f65d24e"

inherit libretro-core

DESCRIPTION="pcsx1 libretro core"
HOMEPAGE="https://github.com/libretro/pcsx1-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/pcsx1-libretro-35dabb85ff3af6825820f54090d344945f65d24e"

# Upstream makefile: Makefile.libretro
