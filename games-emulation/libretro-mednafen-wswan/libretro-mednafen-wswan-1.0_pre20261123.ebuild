# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/beetle-wswan-libretro"
LIBRETRO_COMMIT_SHA="4b01295838ea89e3f1355bbe4cb5cf98aa6108cd"

inherit libretro-core

DESCRIPTION="mednafen_wswan libretro core"
HOMEPAGE="https://github.com/libretro/beetle-wswan-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/beetle-wswan-libretro-4b01295838ea89e3f1355bbe4cb5cf98aa6108cd"
