# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="has207/xenia-edge"
LIBRETRO_COMMIT_SHA="6841e1d66a142dcf8426b675800aa2715a7491a3"

inherit libretro-core

S="${WORKDIR}/xenia-edge-6841e1d66a142dcf8426b675800aa2715a7491a3"

DESCRIPTION="xenia_edge libretro core"
HOMEPAGE="https://github.com/has207/xenia-edge"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"
