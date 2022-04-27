# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="tegra udrm to GBM mesa backend loader wrapper"
HOMEPAGE="https://github.com/OE4T/tegra-udrm-gbm"
SRC_URI="https://github.com/OE4T/tegra-udrm-gbm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=media-libs/mesa-21.2[gbm(+)]
	x11-libs/libdrm
	sys-libs/tegra-tx1-drivers"
	
DEPEND="${RDEPEND}"
