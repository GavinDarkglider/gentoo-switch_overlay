# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="warmenhoven/amiarcadia"
LIBRETRO_COMMIT_SHA="8ca27c925833fe0021475155512c7f467924f647"

inherit libretro-core

DESCRIPTION="amiarcadia libretro core"
HOMEPAGE="https://github.com/warmenhoven/amiarcadia"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/amiarcadia-8ca27c925833fe0021475155512c7f467924f647"
