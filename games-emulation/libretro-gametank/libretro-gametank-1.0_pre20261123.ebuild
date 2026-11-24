# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="SundownerSport/gametank-libretro"
LIBRETRO_COMMIT_SHA="b9d0436ba70786912e9ef2dda9b3b3ee8e1c3c13"

inherit libretro-core

DESCRIPTION="gametank libretro core"
HOMEPAGE="https://github.com/SundownerSport/gametank-libretro"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/gametank-libretro-b9d0436ba70786912e9ef2dda9b3b3ee8e1c3c13"
