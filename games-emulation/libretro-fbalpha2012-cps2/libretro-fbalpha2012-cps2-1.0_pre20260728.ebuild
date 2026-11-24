# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha2012_cps2"
LIBRETRO_COMMIT_SHA="e3f3ae46f120228b74d41e2b2862f1fbf1d7eb5b"

inherit libretro-core

S="${WORKDIR}/fbalpha2012_cps2-e3f3ae46f120228b74d41e2b2862f1fbf1d7eb5b"

DESCRIPTION="fbalpha2012_cps2 libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha2012_cps2.git"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: makefile.libretro
