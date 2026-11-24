# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="warmenhoven/tia"
LIBRETRO_COMMIT_SHA="6ae5bf998fe7a7842294089db17fc86fd73db1f0"

inherit libretro-core

S="${WORKDIR}/tia-6ae5bf998fe7a7842294089db17fc86fd73db1f0"

DESCRIPTION="tia libretro core"
HOMEPAGE="https://github.com/warmenhoven/tia"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
