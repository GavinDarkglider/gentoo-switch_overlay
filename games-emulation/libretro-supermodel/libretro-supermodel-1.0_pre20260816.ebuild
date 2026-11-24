# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/supermodel"
LIBRETRO_COMMIT_SHA="5227eaf498abbcf4f622f6a3ca69ea73cbe0f986"

inherit libretro-core

S="${WORKDIR}/supermodel-5227eaf498abbcf4f622f6a3ca69ea73cbe0f986"

DESCRIPTION="supermodel libretro core"
HOMEPAGE="https://github.com/libretro/supermodel"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
