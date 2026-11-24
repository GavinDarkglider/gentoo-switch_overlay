# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/fbalpha2012"
LIBRETRO_COMMIT_SHA="0ce31536bef3162fe7e69ff5f555334ec4913cef"

inherit libretro-core

DESCRIPTION="fbalpha2012 libretro core"
HOMEPAGE="https://github.com/libretro/fbalpha2012"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/fbalpha2012-0ce31536bef3162fe7e69ff5f555334ec4913cef/svn-current/trunk"

# Upstream makefile: makefile.libretro
