# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="doublegate/RustyNES"
LIBRETRO_COMMIT_SHA="e4401b7f3c5636b9ff43c7c8f095b45561e602bb"

inherit libretro-core

DESCRIPTION="rustynes libretro core"
HOMEPAGE="https://github.com/doublegate/RustyNES"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/RustyNES-e4401b7f3c5636b9ff43c7c8f095b45561e602bb"

# Upstream makefile: crates/rustynes-libretro/Makefile
