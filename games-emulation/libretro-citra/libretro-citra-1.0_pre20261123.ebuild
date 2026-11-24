# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/citra"
LIBRETRO_COMMIT_SHA="a0483e9abe8134ae6b290cdca7d49cb77689f05b"

inherit libretro-core

DESCRIPTION="citra libretro core"
HOMEPAGE="https://github.com/libretro/citra"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/citra-a0483e9abe8134ae6b290cdca7d49cb77689f05b"
