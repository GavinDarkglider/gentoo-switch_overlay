# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/Mu"
LIBRETRO_COMMIT_SHA="afaeb157b8ba38a4a9bdf426ba663f7efb2cc6f8"

inherit libretro-core

DESCRIPTION="mu libretro core"
HOMEPAGE="https://github.com/libretro/Mu"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Mu-afaeb157b8ba38a4a9bdf426ba663f7efb2cc6f8/libretroBuildSystem"

# Upstream makefile: Makefile
