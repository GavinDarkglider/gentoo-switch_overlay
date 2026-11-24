# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/smsplus-gx"
LIBRETRO_COMMIT_SHA="ebb3fe198834b655162aed6a58cba270ff3de508"

inherit libretro-core

DESCRIPTION="smsplus libretro core"
HOMEPAGE="https://github.com/libretro/smsplus-gx"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/smsplus-gx-ebb3fe198834b655162aed6a58cba270ff3de508"

# Upstream makefile: Makefile.libretro
