# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="kurtjd/jaxe"
LIBRETRO_COMMIT_SHA="c767afd785e01a15bcd575a2d93b737add82b675"

inherit libretro-core

DESCRIPTION="jaxe libretro core"
HOMEPAGE="https://github.com/kurtjd/jaxe"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/jaxe-c767afd785e01a15bcd575a2d93b737add82b675"

# Upstream makefile: Makefile.libretro
