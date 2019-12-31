# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

ETYPE="sources"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
         https://gitlab.com/switchroot/l4t-kernel-4.9"

IUSE="+cypress_wifi"

K_SECURITY_UNSUPPORTED="yes"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="189"

SWITCHROOT_VER="linux-rel32"
DTSTREE_VER="32.2"

inherit kernel-2
detect_version
detect_arch
inherit git-r3

SRC_URI="${GENPATCHES_URI}"

DESCRIPTION="Nintendo Switch kernel sources for the ${KV_MAJOR}.${KV_MINOR} switchroot ${SWITCHROOT_VER} tree"

RDEPEND="sys-kernel/nintendo-switch-l4t-dtstree:${DTSTREE_VER}[cypress_wifi=]"

S="${WORKDIR}"/linux-l4t-"${PVR}"-nintendo

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-${KV_MAJOR}.${KV_MINOR}"
	if use cypress_wifi; then
		EGIT_BRANCH="${SWITCHROOT_VER}-integrated-backports"
	else
		EGIT_BRANCH="${SWITCHROOT_VER}"
	fi
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*
}


src_prepare() {
	einfo "Apply Gentoo patches"
	mkdir "${WORKDIR}"/genpatches
	cd "${WORKDIR}"/genpatches
	unpack genpatches-4.9-"${K_GENPATCHES_VER}".base.tar.xz
	unpack genpatches-4.9-"${K_GENPATCHES_VER}".extras.tar.xz
	cd "${S}"
	for PATCH in ${GENTOO_PATCHES}; do
		unipatch "${WORKDIR}"/genpatches/"${PATCH}"
	done

	eapply_user
}

src_configure() {
	SRC_CONFIGFILE="${FILESDIR}"/gentoo_switch_defconfig-"${KV_MAJOR}.${KV_MINOR}"-"$(echo "${DTSTREE_VER}" | cut -d. -f1)"
	DST_CONFIGFILE="${S}"/arch/arm64/configs/gentoo_switch_defconfig
	einfo "Use ${SRC_CONFIGFILE} configuration"
	cp "${SRC_CONFIGFILE}"  "${DST_CONFIGFILE}" || die "copy failed"


	EXTRAVERSION=".${DTSTREE_VER}-nintendo-switch-l4t"
	einfo "Adjust extraversion to ${EXTRAVERSION}"
	unpack_set_extraversion

	einfo ""
	einfo "Use 'make-with-dts-${DTSTREE_VER}.sh gentoo_switch_defconfig' to apply prepared nintendo switch optimized configuration"
	einfo ""
}

src_install() {
	kernel-2_src_install
	dodir /usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"
	mv "${D}"/usr/src/linux-l4t-"${PVR}"-nintendo "${D}"/usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"
	dosym /usr/src/nintendo-switch-l4t-dtstree-"${DTSTREE_VER}"/linux-l4t-"${PVR}"-nintendo /usr/src/linux-l4t-"${PVR}"-nintendo
}
