# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/parallel-dc"
LIBRETRO_COMMIT_SHA="18b092ffa6e7dece53c31b4fa3cdade7ea3c1363"

inherit libretro-core

S="${WORKDIR}/parallel-dc-18b092ffa6e7dece53c31b4fa3cdade7ea3c1363"

DESCRIPTION="parallel_dc libretro core"
HOMEPAGE="https://github.com/libretro/parallel-dc"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
