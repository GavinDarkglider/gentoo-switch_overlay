# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="Zlika/theodore"
LIBRETRO_COMMIT_SHA="4d469ce0f71ee046ceb78cdbf8e9f18364aaa918"

inherit libretro-core

DESCRIPTION="theodore libretro core"
HOMEPAGE="https://github.com/Zlika/theodore"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/theodore-4d469ce0f71ee046ceb78cdbf8e9f18364aaa918"

myemakeargs=( platform=unix )
