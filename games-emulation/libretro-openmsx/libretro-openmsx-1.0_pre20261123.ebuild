# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="openMSX/openMSX"
LIBRETRO_COMMIT_SHA="fcf77ffcf914d9083fb2652fb7a6ab161c90aa0a"

inherit libretro-core

S="${WORKDIR}/openMSX-fcf77ffcf914d9083fb2652fb7a6ab161c90aa0a"

DESCRIPTION="openmsx libretro core"
HOMEPAGE="https://github.com/openMSX/openMSX"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
