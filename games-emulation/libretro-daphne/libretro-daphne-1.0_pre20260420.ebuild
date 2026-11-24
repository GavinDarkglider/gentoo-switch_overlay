# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/daphne"
LIBRETRO_COMMIT_SHA="6f1695dd1f376060666eec0a416ff56bb6c9cccc"

inherit libretro-core

LIBRETRO_CORE_NAME="daphne"

S="${WORKDIR}/daphne-6f1695dd1f376060666eec0a416ff56bb6c9cccc"

DESCRIPTION="libretro-daphne libretro core"
HOMEPAGE="https://github.com/libretro/daphne"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
