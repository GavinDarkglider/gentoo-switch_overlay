# Copyright 1999-2020 Alexander Weber
# Copyright 1999-2020 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

ETYPE="sources"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
          https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"

IUSE="+genpatches kali_patches"

K_SECURITY_UNSUPPORTED="yes"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="189"

SWITCHROOT_VER="linux-rel32"
DTSTREE_VER="32.2"

inherit kernel-2
detect_version
detect_arch
inherit git-r3

SRC_URI="
genpatches? ( https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-4.9-${K_GENPATCHES_VER}.base.tar.xz
              https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-4.9-${K_GENPATCHES_VER}.extras.tar.xz )"

DESCRIPTION="Nintendo Switch kernel sources for the ${KV_MAJOR}.${KV_MINOR} switchroot ${SWITCHROOT_VER} tree"

RDEPEND="sys-kernel/nintendo-switch-l4t-dtstree:${DTSTREE_VER}"

S="${WORKDIR}"/linux-l4t-"${PVR}"-nintendo

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-${KV_MAJOR}.${KV_MINOR}"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*
}


src_prepare() {
	if use genpatches ]]; then
		einfo "Apply Gentoo patches"
		mkdir "${WORKDIR}"/genpatches
		cd "${WORKDIR}"/genpatches
		unpack genpatches-4.9-"${K_GENPATCHES_VER}".base.tar.xz
		unpack genpatches-4.9-"${K_GENPATCHES_VER}".extras.tar.xz
		cd "${S}"
		for PATCH in ${GENTOO_PATCHES}; do
			unipatch "${WORKDIR}"/genpatches/"${PATCH}"
		done
	fi
	if use kali_patches; then
		einfo "Apply Kali wifi injection patches, and BashBunny patches"
		eapply ${FILESDIR}/kali-wifi-injection-4.9.patch
		eapply ${FILESDIR}/0001-wireless-carl9170-Enable-sniffer-mode-promisx-flag-t.patch
			eapply ${FILESDIR}/usb_gadget_bashbunny_patches-l4t_4.9.patch
	fi
	eapply_user
}

src_configure() {
	EXTRAVERSION=".${DTSTREE_VER}-nintendo-switch-l4t"
	einfo "Adjust extraversion to ${EXTRAVERSION}"
	unpack_set_extraversion

	einfo ""
	einfo "Use 'make-with-dts-${DTSTREE_VER}.sh tegra_linux_defconfig' to apply prepared nintendo switch optimized configuration"
	einfo ""
}

src_install() {
	kernel-2_src_install
	dodir /usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"
	mv "${D}"/usr/src/linux-l4t-"${PVR}"-nintendo "${D}"/usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"
	dosym /usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"/linux-l4t-"${PVR}"-nintendo /usr/src/linux-l4t-"${PVR}"-nintendo
}
