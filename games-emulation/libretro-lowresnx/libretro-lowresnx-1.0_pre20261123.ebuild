# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="timoinutilis/lowres-nx"
LIBRETRO_COMMIT_SHA="63d5988f74e1eea2ecd6ea0445a8ce260b0a9822"

inherit libretro-core

DESCRIPTION="lowresnx libretro core"
HOMEPAGE="https://github.com/timoinutilis/lowres-nx"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/lowres-nx-63d5988f74e1eea2ecd6ea0445a8ce260b0a9822/platform/LibRetro"

# Upstream makefile: Makefile
