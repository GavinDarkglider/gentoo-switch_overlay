# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="icculus/DirkSimple"
LIBRETRO_COMMIT_SHA="d5d75f97af34690010166a786ee41e15dd142c15"

inherit libretro-core

DESCRIPTION="dirksimple libretro core"
HOMEPAGE="https://github.com/icculus/DirkSimple"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/DirkSimple-d5d75f97af34690010166a786ee41e15dd142c15"

myemakeargs=( -DLIBRETRO=ON )
