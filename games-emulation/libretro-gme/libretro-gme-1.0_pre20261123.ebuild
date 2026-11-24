# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-gme"
LIBRETRO_COMMIT_SHA="1562f6207a066e9807243c89648d1cb44e411971"

inherit libretro-core

DESCRIPTION="gme libretro core"
HOMEPAGE="https://github.com/libretro/libretro-gme"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/libretro-gme-1562f6207a066e9807243c89648d1cb44e411971"
