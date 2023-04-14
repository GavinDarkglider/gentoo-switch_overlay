# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installkernel script for l4t kernel"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* ~arm64"

RDEPEND="
	>=sys-apps/debianutils-4.9-r1
	!<sys-apps/debianutils-4.9-r1[installkernel(+)]
	!sys-kernel/installkernel-systemd-boot
	dev-embedded/u-boot-tools"

S="${WORKDIR}"

src_install() {
	into /
	#dosbin "${FILESDIR}"/installkernel
	dosbin "${FILESDIR}"/mkdtboimg.py
	keepdir /etc/kernel/postinst.d
}
