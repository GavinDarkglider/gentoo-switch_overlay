# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/opera-libretro"
LIBRETRO_COMMIT_SHA="e01f1dc83e325596b2d09e7f286b0219459433e6"

inherit libretro-core

DESCRIPTION="opera libretro core"
HOMEPAGE="https://github.com/libretro/opera-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/opera-libretro-e01f1dc83e325596b2d09e7f286b0219459433e6"
