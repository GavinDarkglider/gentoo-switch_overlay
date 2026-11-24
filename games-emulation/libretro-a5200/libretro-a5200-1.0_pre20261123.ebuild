# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/a5200"
LIBRETRO_COMMIT_SHA="40c6f2f1ad4a3145b328d5baaf010fae6c7e752b"

inherit libretro-core

DESCRIPTION="a5200 libretro core"
HOMEPAGE="https://github.com/libretro/a5200"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/a5200-40c6f2f1ad4a3145b328d5baaf010fae6c7e752b"

# Upstream makefile: Makefile
