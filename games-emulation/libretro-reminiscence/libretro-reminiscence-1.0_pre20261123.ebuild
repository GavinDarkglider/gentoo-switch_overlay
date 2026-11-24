# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/REminiscence"
LIBRETRO_COMMIT_SHA="e6c0b0039258004f8bc377ddb88c0e931db131ce"

inherit libretro-core

DESCRIPTION="reminiscence libretro core"
HOMEPAGE="https://github.com/libretro/REminiscence"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/REminiscence-e6c0b0039258004f8bc377ddb88c0e931db131ce"

# Upstream makefile: Makefile
