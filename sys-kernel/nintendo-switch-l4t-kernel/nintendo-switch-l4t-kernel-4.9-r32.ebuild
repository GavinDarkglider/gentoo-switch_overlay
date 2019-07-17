# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~arm64"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
         https://gitlab.com/switchroot/l4t-kernel-4.9"

IUSE="kali_patches lakka_patches +gentoo_patches hid-joycon -lp0 -minerva"

K_SECURITY_UNSUPPORTED="yes"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="189"

DESCRIPTION="Nintendo Switch kernel"

inherit kernel-2
detect_version
detect_arch

SRC_URI="https://gitlab.com/switchroot/l4t-kernel-4.9/-/archive/rel30-rel32stack/l4t-kernel-4.9-rel30-rel32stack.tar.bz2
         https://gitlab.com/switchroot/l4t-kernel-nvidia/-/archive/rel32-rel32stack/l4t-kernel-nvidia-rel32-rel32stack.tar.bz2
         https://gitlab.com/switchroot/l4t-platform-t210-switch/-/archive/rel-30-r3/l4t-platform-t210-switch-rel-30-r3.tar.bz2
         https://nv-tegra.nvidia.com/gitweb/?p=linux-nvgpu.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> linux-nvgpu-r32.1.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/soc/tegra.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> soc-tegra-tegra-l4t-r32.1.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/soc/t210.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> soc-tegra-t210-tegra-l4t-r32.1.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/platform/tegra/common.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> platform-tegra-common-tegra-l4t-r32.1.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/platform/t210/common.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> platform-tegra-t210-common-tegra-l4t-r32.1.tar.gz
         ${GENPATCHES_URI}"

DEPEND="sys-firmware/jetson-tx1-firmware
        sys-firmware/nintendo-switch-firmware
        sys-kernel/linux-firmware
        app-editors/vim-core"

GENTOO_PATCHES="
1109_linux-4.9.110.patch
1110_linux-4.9.111.patch
1111_linux-4.9.112.patch
1500_XATTR_USER_PREFIX.patch
1520_security-apparmor-Use-POSIX-compatible-printf.patch
1701_ia64_fix_ptrace.patch
2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch
2300_enable-poweroff-on-Mac-Pro-11.patch
2900_dev-root-proc-mount-fix.patch
4400_alpha-sysctl-uac.patch
4567_distro-Gentoo-Kconfig.patch"

src_unpack() {
	S="${WORKDIR}"/kernel
	mkdir "${S}"
	cd "${S}"
	unpack l4t-kernel-4.9-rel30-rel32stack.tar.bz2
	mv l4t-kernel-4.9* kernel-4.9

	cd "${S}"
	unpack l4t-kernel-nvidia-rel32-rel32stack.tar.bz2
	mv l4t-kernel-nvidia* nvidia

	unpack linux-nvgpu-r32.1.tar.gz
	mv linux-nvgpu nvgpu

	mkdir -p "${S}"/hardware/nvidia/platform/t210/
	cd "${S}"/hardware/nvidia/platform/t210/
	unpack l4t-platform-t210-switch-rel-30-r3.tar.bz2
	mv l4t-platform-t210-switch* switch

	mkdir -p "${S}"/hardware/nvidia/soc/
	cd "${S}"/hardware/nvidia/soc/
	unpack soc-tegra-tegra-l4t-r32.1.tar.gz
	unpack soc-tegra-t210-tegra-l4t-r32.1.tar.gz


	mkdir -p "${S}"/hardware/nvidia/platform/tegra/
	cd "${S}"/hardware/nvidia/platform/tegra/
	unpack platform-tegra-common-tegra-l4t-r32.1.tar.gz

	mkdir -p "${S}"/hardware/nvidia/platform/t210/
	cd "${S}"/hardware/nvidia/platform/t210/
	unpack platform-tegra-t210-common-tegra-l4t-r32.1.tar.gz

	cd "${S}"/kernel-4.9
	unipatch "${FILESDIR}"/l4t-kernel-drop-emc-optimization-flag.patch
	unipatch "${FILESDIR}"/stmfts-fix-touch-sync.patch
	unipatch "${FILESDIR}"/stmfts-disable-input-tuning.patch
	unipatch "${FILESDIR}"/fix-usb0-rndis0-name.patch

	if use kali_patches; then
		einfo "Apply Kali patches"
		unipatch "${FILESDIR}"/kali-wifi-injection-4.9.patch
		unipatch "${FILESDIR}"/0001-wireless-carl9170-Enable-sniffer-mode-promisx-flag-t.patch
		unipatch "${FILESDIR}"/usb_gadget_bashbunny_patches-l4t_4.9.patch
	fi

	if use hid-joycon; then
		einfo "Upgrade Joycon Driver - Currently broken"
		patch -p1 -R < "${FILESDIR}"/hid-switchcon-2.patch
		patch -p1 -R < "${FILESDIR}"/hid-switchcon-1.patch
		unipatch "${FILESDIR}"/hid-joycon-1.patch
		unipatch "${FILESDIR}"/hid-joycon-2.patch
		unipatch "${FILESDIR}"/hid-joycon-3.patch
		unipatch "${FILESDIR}"/hid-joycon-4.patch
		unipatch "${FILESDIR}"/hid-joycon-5.patch
		ewarn "These patches are currently broken, and may not work"
		ewarn "right. If they do work, you will need to install a special"
		ewarn "application to pair joycons. I will add this app to"
		ewarn "the repository soon enough, then will update this"
		ewarn "I am currently working with the developer to get the issue"
		ewarn "fixed."
	fi

	if use lakka_patches; then
		einfo "Apply Lakka patches"
		# Source: https://github.com/lakka-switch/Lakka-LibreELEC/tree/master/projects/Switch/devices/L4T/packages/l4t-kernel/patches
		unipatch "${FILESDIR}"/l4t-kernel-add-serdev_device_write.patch
		unipatch "${FILESDIR}"/l4t-kernel-0002-input-working-Joy-Con-rails-driver.patch
		unipatch "${FILESDIR}"/l4t-kernel-0001-tegra-Allow-UART-pins-to-be-inverted.patch

		cd "${S}"/hardware/nvidia/platform/t210/switch
		unipatch "${FILESDIR}"/l4t-platform-t210-switch-0001-jc-pinmux.patch
		unipatch "${FILESDIR}"/l4t-platform-t210-switch-0002-jc-driver.patch

		ewarn "Lakka Patches Break Sleep Mode."
		ewarn "This will be added to default build"
		ewarn "when this issue is fixed."
	fi

	if use gentoo_patches; then
		einfo "Apply Gentoo patches"
		mkdir "${S}"/genpatches
		cd "${S}"/genpatches
		unpack genpatches-4.9-"${K_GENPATCHES_VER}".base.tar.xz
		unpack genpatches-4.9-"${K_GENPATCHES_VER}".extras.tar.xz
		cd "${S}"/kernel-4.9
		for PATCH in ${GENTOO_PATCHES}; do
			unipatch "${S}"/genpatches/"${PATCH}"
		done
	fi
	if use lp0; then
		einfo "Applying lp0 Patches from Android Kernel"
		unipatch "${FILESDIR}"/revert-disable-psci-suspend-for-now.patch
		ewarn "These patches Are work with this kernel, but LP0 deep sleep"
		ewarn "freezes video on wake, so support was removed from coreboot/atf for now."
	fi
	if use minerva; then
		einfo "Applying required patches for Minerva T.C."
		unipatch "${FILESDIR}"/read-mtc-table-addr-from-atf.patch
	fi
}

src_configure() {
	S="${WORKDIR}"/kernel/kernel-4.9
	einfo "Use ${FILESDIR}/gentoo_switch_defconfig configuration"
	cd "${S}"
	cp ${FILESDIR}/gentoo_switch_defconfig  .config || die "copy failed"
	if use hid-joycon; then
		sed -i 's/CONFIG_HID_SWITCHCON=y/CONFIG_HID_JOYCON=y/g' .config
		echo CONFIG_JOYCON_FF=y >> .config
	fi
	if use lakka_patches; then
		echo CONFIG_JOYSTICK_JOYCON=y >> .config
	fi
	einfo "Adjust gentoo version"
	unpack_set_extraversion

	CUSTOM_CONFIGFILE="${PORTAGE_CONFIGROOT}/etc/portage/nintendo-switch-l4t-kernel.config"
	if [ -f "${CUSTOM_CONFIGFILE}" ]; then
		einfo "Add custom configuration ${CUSTOM_CONFIGFILE}"
		cat "${FILESDIR}/switch_gentoo.config" >> .config
	else
		einfo "Skip custom configuration. ${CUSTOM_CONFIGFILE} not found"
	fi

	einfo "Prepare the kernel for build"
	emake olddefconfig 2>/dev/null || die "emake olddefconfig failed"
	emake prepare || die "emake prepare failed"
	emake modules_prepare || die "emake modules_prepare failed"
}

src_compile() {
	# Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	export LDFLAGS=""

	# GCC-8 legacy fix
	export KCFLAGS="-Wno-error=stringop-truncation -Wno-error=stringop-overflow="

	emake tegra-dtstree="../hardware/nvidia/" || die "emake failed"
}

src_install() {
	dodir /boot
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake modules_install || die "emake modules_install failed"
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake install || die "make install failed"

	insinto /boot
	doins arch/arm64/boot/dts/tegra210-icosa.dtb
}
