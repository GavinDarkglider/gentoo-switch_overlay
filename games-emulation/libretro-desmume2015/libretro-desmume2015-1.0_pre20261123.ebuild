# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/desmume2015"
LIBRETRO_COMMIT_SHA="422b688009ccb9f2917c086a8fe79c8cecb030ae"

inherit libretro-core

DESCRIPTION="desmume2015 libretro core"
HOMEPAGE="https://github.com/libretro/desmume2015"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/desmume2015-422b688009ccb9f2917c086a8fe79c8cecb030ae/desmume"

# Upstream makefile: Makefile.libretro
