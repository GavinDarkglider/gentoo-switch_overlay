# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="JesseTG/melonds-ds"
LIBRETRO_COMMIT_SHA="f394adbacb5722ee97c1b37c8064da9a25818310"

inherit libretro-core

DESCRIPTION="melondsds libretro core"
HOMEPAGE="https://github.com/JesseTG/melonds-ds"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/melonds-ds-f394adbacb5722ee97c1b37c8064da9a25818310"
