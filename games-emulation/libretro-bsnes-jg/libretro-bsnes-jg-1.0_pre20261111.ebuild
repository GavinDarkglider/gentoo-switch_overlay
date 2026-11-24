# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/bsnes-jg"
LIBRETRO_COMMIT_SHA="7ed3cf55cbe3e88414d921db88388ec9e60c6db0"

inherit libretro-core

S="${WORKDIR}/bsnes-jg-7ed3cf55cbe3e88414d921db88388ec9e60c6db0"

DESCRIPTION="bsnes-jg libretro core"
HOMEPAGE="https://github.com/libretro/bsnes-jg"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"
