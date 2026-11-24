# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/parallel-n64"
LIBRETRO_COMMIT_SHA="e854c84a175388bfb4643ff654522be8c941baf1"

inherit libretro-core

DESCRIPTION="parallel_n64 libretro core"
HOMEPAGE="https://github.com/libretro/parallel-n64"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/parallel-n64-e854c84a175388bfb4643ff654522be8c941baf1"
