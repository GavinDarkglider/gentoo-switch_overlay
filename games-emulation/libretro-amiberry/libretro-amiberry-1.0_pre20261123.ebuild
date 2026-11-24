# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="BlitterStudio/amiberry"
LIBRETRO_COMMIT_SHA="afbf37e789c7abb4ccef2f9a651d15a369555df7"

inherit libretro-core

DESCRIPTION="amiberry libretro core"
HOMEPAGE="https://github.com/BlitterStudio/amiberry"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/amiberry-afbf37e789c7abb4ccef2f9a651d15a369555df7/libretro"

# Upstream makefile: Makefile
