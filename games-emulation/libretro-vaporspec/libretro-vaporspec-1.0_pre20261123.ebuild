# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="minkcv/vm"
LIBRETRO_COMMIT_SHA="11f63848a592644722ea1240b4b96785db9b009f"

inherit libretro-core

DESCRIPTION="vaporspec libretro core"
HOMEPAGE="https://github.com/minkcv/vm"
LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/vm-11f63848a592644722ea1240b4b96785db9b009f/machine"

# Upstream makefile: Makefile.libretro
