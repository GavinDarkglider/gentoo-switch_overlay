# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/frodo-libretro"
LIBRETRO_COMMIT_SHA="891d20102a8894dd4fce73fb8bd2f623483fd05f"

inherit libretro-core

DESCRIPTION="frodo libretro core"
HOMEPAGE="https://github.com/libretro/frodo-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/frodo-libretro-891d20102a8894dd4fce73fb8bd2f623483fd05f"

# Upstream makefile: Makefile
