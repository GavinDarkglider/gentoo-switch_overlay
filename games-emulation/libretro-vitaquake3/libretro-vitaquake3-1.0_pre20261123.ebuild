# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/vitaquake3"
LIBRETRO_COMMIT_SHA="61374f650f42c4f25c215ea1f8db992af162ada6"

inherit libretro-core

DESCRIPTION="vitaquake3 libretro core"
HOMEPAGE="https://github.com/libretro/vitaquake3"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vitaquake3-61374f650f42c4f25c215ea1f8db992af162ada6"

# Upstream makefile: Makefile
