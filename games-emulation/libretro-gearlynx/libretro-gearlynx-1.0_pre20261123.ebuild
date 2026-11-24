# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="drhelius/Gearlynx"
LIBRETRO_COMMIT_SHA="662bab87a06f3f9f5f890b33dff492ec3127ad55"

inherit libretro-core

DESCRIPTION="gearlynx libretro core"
HOMEPAGE="https://github.com/drhelius/Gearlynx"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/Gearlynx-662bab87a06f3f9f5f890b33dff492ec3127ad55/platforms/libretro"

# Upstream makefile: Makefile
