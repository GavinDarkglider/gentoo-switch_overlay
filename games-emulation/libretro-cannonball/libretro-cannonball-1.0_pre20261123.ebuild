# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/cannonball"
LIBRETRO_COMMIT_SHA="0d83575d920ea4c0a280847a19d7802f673e6a68"

inherit libretro-core

DESCRIPTION="cannonball libretro core"
HOMEPAGE="https://github.com/libretro/cannonball"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/cannonball-0d83575d920ea4c0a280847a19d7802f673e6a68"
