# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/libretro-video-processor"
LIBRETRO_COMMIT_SHA="8fe4751f0039a1b645bf750531fcfc234958a7ac"

inherit libretro-core

S="${WORKDIR}/libretro-video-processor-8fe4751f0039a1b645bf750531fcfc234958a7ac"

DESCRIPTION="video_processor libretro core"
HOMEPAGE="https://github.com/libretro/libretro-video-processor.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"

# Upstream makefile: Makefile
