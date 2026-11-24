# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/mame2010-libretro"
LIBRETRO_COMMIT_SHA="16a9093cf0fded4895c035e7fb01e88f38eaf08d"

inherit libretro-core

PATCHES=( "${FILESDIR}/mame2010-1.0_pre20261123-001-path-default-slash.patch" )

DESCRIPTION="mame2010 libretro core"
HOMEPAGE="https://github.com/libretro/mame2010-libretro"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/mame2010-libretro-16a9093cf0fded4895c035e7fb01e88f38eaf08d"

src_compile() {
	local args=( CC=$(tc-getCC) CXX=$(tc-getCXX) LD=$(tc-getCC) PTR64=1 ARM_ENABLED=1 LCPU=arm64 )
	emake "${args[@]}" maketree || die
	emake "${args[@]}" || die
}
