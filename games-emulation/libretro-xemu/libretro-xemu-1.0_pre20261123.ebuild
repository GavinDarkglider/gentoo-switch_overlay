# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="xemu-project/xemu"
LIBRETRO_COMMIT_SHA="76f156ce1fb27ff7cef9009e4e639e682a9c7eef"

inherit libretro-core

S="${WORKDIR}/xemu-76f156ce1fb27ff7cef9009e4e639e682a9c7eef"

DESCRIPTION="xemu libretro core"
HOMEPAGE="https://github.com/xemu-project/xemu"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
