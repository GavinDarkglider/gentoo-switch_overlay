# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="Vita3K/Vita3K"
LIBRETRO_COMMIT_SHA="cde9ceb900e30e17d10e4f32938a1a2d9b52a234"

inherit libretro-core

S="${WORKDIR}/Vita3K-cde9ceb900e30e17d10e4f32938a1a2d9b52a234"

DESCRIPTION="vita3k libretro core"
HOMEPAGE="https://github.com/Vita3K/Vita3K"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
