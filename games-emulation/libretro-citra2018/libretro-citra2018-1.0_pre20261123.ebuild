# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/citra2018"
LIBRETRO_COMMIT_SHA="95e2f06c179c8daf44fa344c206f549cf332d21b"

inherit libretro-core

DESCRIPTION="citra2018 libretro core"
HOMEPAGE="https://github.com/libretro/citra2018"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/citra2018-95e2f06c179c8daf44fa344c206f549cf332d21b"
