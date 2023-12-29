# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Installkernel script for l4t kernel"
HOMEPAGE="https://gitlab.com/bell07/gentoo-switch_overlay"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64"
IUSE="+dracut"

RDEPEND="
	sys-apps/debianutils
	dev-embedded/u-boot-tools
	!sys-kernel/installkernel-systemd"

S="${WORKDIR}"

src_install() {
	into /
	dosbin "${FILESDIR}"/installkernel
	dosbin "${FILESDIR}"/mkdtboimg.py
	keepdir /etc/kernel/postinst.d
	keepdir /etc/kernel/preinst.d

	if use dracut; then
		exeinto /etc/kernel/preinst.d
		doexe "${FILESDIR}"/50-dracut.install
	fi
}
