# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/omicron"
LIBRETRO_COMMIT_SHA="0181fbad079addb1fca895325c711f8f91397be4"

inherit libretro-core

S="${WORKDIR}/Omicron-0181fbad079addb1fca895325c711f8f91397be4"

DESCRIPTION="omicron libretro core"
HOMEPAGE="https://github.com/libretro/omicron"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="arm64"
