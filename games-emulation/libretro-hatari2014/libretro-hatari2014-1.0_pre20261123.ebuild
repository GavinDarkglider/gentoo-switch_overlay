# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/hatari"
LIBRETRO_COMMIT_SHA="4edc56f4e2add886ed5406854d12f95fdfdf67b6"

inherit libretro-core

DESCRIPTION="hatari2014 libretro core"
HOMEPAGE="https://github.com/libretro/hatari"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/hatari-4edc56f4e2add886ed5406854d12f95fdfdf67b6"

# Upstream makefile: Makefile.libretro
