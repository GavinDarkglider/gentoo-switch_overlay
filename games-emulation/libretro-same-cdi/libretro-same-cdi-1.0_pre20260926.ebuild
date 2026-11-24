# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/same_cdi"
LIBRETRO_COMMIT_SHA="ff9bb99a50d518aef6d2add1c49b7c44447e3e78"

inherit libretro-core

S="${WORKDIR}/same_cdi-ff9bb99a50d518aef6d2add1c49b7c44447e3e78"

DESCRIPTION="same_cdi libretro core"
HOMEPAGE="https://github.com/libretro/same_cdi"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
