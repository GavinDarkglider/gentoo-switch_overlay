# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="nbarkhina/numero"
LIBRETRO_COMMIT_SHA="c0b07a39782feafebcde0c8ccfa91fc92732c999"

inherit libretro-core

DESCRIPTION="numero libretro core"
HOMEPAGE="https://github.com/nbarkhina/numero"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/numero-c0b07a39782feafebcde0c8ccfa91fc92732c999"

# Upstream makefile: Makefile.libretro
