# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LIBRETRO_REPO_NAME="libretro/FreeChaF"
LIBRETRO_COMMIT_SHA="76c7a84f1f7e80f3e6f2bba96fe100cb24e99124"

inherit libretro-core

DESCRIPTION="freechaf libretro core"
HOMEPAGE="https://github.com/libretro/FreeChaF"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/FreeChaF-76c7a84f1f7e80f3e6f2bba96fe100cb24e99124"

# Upstream makefile: Makefile
