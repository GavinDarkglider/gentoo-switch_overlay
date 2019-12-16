# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

ETYPE="sources"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
         https://gitlab.com/switchroot/l4t-kernel-4.9"

IUSE="kali_patches lakka_patches hid-joycon"

K_SECURITY_UNSUPPORTED="yes"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="189"

SWITCHROOT_VER="rel30-rel32stack"
DTSTREE_VER="30.3"

inherit kernel-2
detect_version
detect_arch
inherit git-r3

SRC_URI="${GENPATCHES_URI}"

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
	if use kali_patches; then
		einfo "Apply Kali patches"
		unipatch "${FILESDIR}"/kali-wifi-injection-4.9.patch
		unipatch "${FILESDIR}"/0001-wireless-carl9170-Enable-sniffer-mode-promisx-flag-t.patch
		unipatch "${FILESDIR}"/usb_gadget_bashbunny_patches-l4t_4.9.patch
	fi

	if use hid-joycon; then
		einfo "Upgrade Joycon Driver"
		patch -p1 -R < "${FILESDIR}"/hid-switchcon-2.patch
		patch -p1 -R < "${FILESDIR}"/hid-switchcon-1.patch
		unipatch "${FILESDIR}"/hid-joycon-1.patch
		unipatch "${FILESDIR}"/hid-joycon-2.patch
		unipatch "${FILESDIR}"/hid-joycon-3.patch
		unipatch "${FILESDIR}"/hid-joycon-4.patch
		unipatch "${FILESDIR}"/hid-joycon-5.patch
		unipatch "${FILESDIR}"/hid-joycon-l4t-fixes.patch
	fi

	if use lakka_patches; then
		einfo "Apply Lakka patches"
		# Source: https://github.com/lakka-switch/Lakka-LibreELEC/tree/master/projects/Switch/devices/L4T/packages/l4t-kernel/patches
		unipatch "${FILESDIR}"/l4t-kernel-add-serdev_device_write.patch
		unipatch "${FILESDIR}"/l4t-kernel-0002-input-working-Joy-Con-rails-driver.patch
		unipatch "${FILESDIR}"/l4t-kernel-0001-tegra-Allow-UART-pins-to-be-inverted.patch

		ewarn "Lakka Patches Break Sleep Mode."
		ewarn "This will be added to default build"
		ewarn "when this issue is fixed."
	fi

	einfo "Apply Gentoo patches"
	mkdir "${WORKDIR}"/genpatches
	cd "${WORKDIR}"/genpatches
	unpack genpatches-4.9-"${K_GENPATCHES_VER}".base.tar.xz
	unpack genpatches-4.9-"${K_GENPATCHES_VER}".extras.tar.xz
	cd "${S}"
	for PATCH in ${GENTOO_PATCHES}; do
		unipatch "${WORKDIR}"/genpatches/"${PATCH}"
	done

	unipatch "${FILESDIR}"/remove-emc_set_clock-spam.patch

	eapply_user
}

src_configure() {
	SRC_CONFIGFILE="${FILESDIR}"/gentoo_switch_defconfig-"${KV_MAJOR}.${KV_MINOR}"-"$(echo "${DTSTREE_VER}" | cut -d. -f1)"
	DST_CONFIGFILE="${S}"/arch/arm64/configs/gentoo_switch_defconfig
	einfo "Use ${SRC_CONFIGFILE} configuration"
	cp "${SRC_CONFIGFILE}"  "${DST_CONFIGFILE}" || die "copy failed"

	if use hid-joycon; then
		sed -i 's/CONFIG_HID_SWITCHCON=/CONFIG_HID_JOYCON=/g' "${DST_CONFIGFILE}"
		echo CONFIG_JOYCON_FF=y >> "${DST_CONFIGFILE}"
	fi
	if use lakka_patches; then
		echo CONFIG_JOYSTICK_JOYCON=y >> "${DST_CONFIGFILE}"
	fi

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
