# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="meancoot/stonesoup-libretro"
inherit git-r3 libretro-core

DESCRIPTION="Kibretro port of Dungeon Crawl - Stone Soup"
HOMEPAGE="https://github.com/meancoot/stonesoup-libretro"
KEYWORDS="~arm64"

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-lang/lua:*"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S=${WORKDIR}/${PN}-${LIBRETRO_COMMIT_SHA}/crawl-ref
