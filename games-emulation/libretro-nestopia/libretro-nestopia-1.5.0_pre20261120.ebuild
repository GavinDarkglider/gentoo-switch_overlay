# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="39e4b456cea6f5e962ce3e65bcdcd7313711a905"

inherit libretro-core

DESCRIPTION="Nestopia libretro port"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${S}/libretro"
