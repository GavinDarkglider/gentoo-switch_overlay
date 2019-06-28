# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~arm64"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
         https://gitlab.com/switchroot/l4t-kernel-4.9"

SRC_URI="https://gitlab.com/switchroot/l4t-kernel-4.9/-/archive/rel30-rel32stack/l4t-kernel-4.9-rel30-rel32stack.tar.bz2
         https://gitlab.com/switchroot/l4t-kernel-nvidia/-/archive/rel32-rel32stack/l4t-kernel-nvidia-rel32-rel32stack.tar.bz2
         https://gitlab.com/switchroot/l4t-platform-t210-switch/-/archive/l4t/l4t-r32.1-4.9/l4t-platform-t210-switch-l4t-l4t-r32.1-4.9.tar.bz2
         https://nv-tegra.nvidia.com/gitweb/?p=linux-nvgpu.git;a=snapshot;h=tegra-l4t-r32.1;sf=tgz -> linux-nvgpu-r32.1.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/soc/tegra.git;a=snapshot;h=rel-30-r2;sf=tgz -> soc-tegra-rel-30-r2.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/soc/t210.git;a=snapshot;h=rel-30-r2;sf=tgz -> soc-tegra-t210-rel-30-r2.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/platform/tegra/common.git;a=snapshot;h=rel-30-r2;sf=tgz -> platform-tegra-common-rel-30-r2.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/platform/t210/common.git;a=snapshot;h=rel-30-r2;sf=tgz -> platform-tegra-t210-common-rel-30-r2.tar.gz
         https://nv-tegra.nvidia.com/gitweb/?p=device/hardware/nvidia/platform/t210/abca.git;a=snapshot;h=rel-30-r2;sf=tgz -> platform-tegra-t210-abca-rel-30-r2.tar.gz"

DEPEND="sys-firmware/jetson-tx1-firmware
        sys-kernel/linux-firmware
        app-editors/vim-core"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Nintendo Switch kernel"
IUSE="kali_patches"

pkg_pretend() {
	ERROR=0
	if ! [ -e "${ROOT}"/lib/firmware/brcm/BCM.hcd ]; then
		eerror "${ROOT}/lib/firmware/brcm/BCM.hcd missed"
		ERROR=1
	fi

	if ! [ -e "${ROOT}"/lib/firmware/brcm/BCM4356A3.hcd ]; then
		eerror "${ROOT}/lib/firmware/brcm/BCM4356A3.hcd missed"
		ERROR=1
	fi   

	if ! [ -e "${ROOT}"/lib/firmware/brcm/brcmfmac4356-pcie.txt  ]; then
		eerror "${ROOT}/lib/firmware/brcm/brcmfmac4356-pcie.txt  missed"
		ERROR=1
	fi  

	if [ "$ERROR" == 1 ] ; then
		die "Please get missed files from anywhere and copy them to /lib/firmware/brcm"
	fi
}

src_unpack() {
	S="${WORKDIR}"/kernel
	mkdir "${S}"
	cd "${S}"
	unpack l4t-kernel-4.9-rel30-rel32stack.tar.bz2
	mv l4t-kernel-4.9* kernel-4.9

	cd "${S}"
	unpack l4t-kernel-nvidia-rel32-rel32stack.tar.bz2 
	unpack linux-nvgpu-r32.1.tar.gz
	mv l4t-kernel-nvidia* nvidia
	mv linux-nvgpu nvgpu

	mkdir -p "${S}"/hardware/nvidia/platform/t210/
	cd "${S}"/hardware/nvidia/platform/t210/
	unpack l4t-platform-t210-switch-l4t-l4t-r32.1-4.9.tar.bz2
	mv l4t-platform-t210-switch* switch

	mkdir -p "${S}"/hardware/nvidia/soc/
	cd "${S}"/hardware/nvidia/soc/
	unpack soc-tegra-rel-30-r2.tar.gz 
	unpack soc-tegra-t210-rel-30-r2.tar.gz

	mkdir -p "${S}"/hardware/nvidia/platform/tegra/
	cd "${S}"/hardware/nvidia/platform/tegra/
	unpack platform-tegra-common-rel-30-r2.tar.gz

	mkdir -p "${S}"/hardware/nvidia/platform/t210/
	cd "${S}"/hardware/nvidia/platform/t210/
	unpack platform-tegra-t210-common-rel-30-r2.tar.gz
	unpack platform-tegra-t210-abca-rel-30-r2.tar.gz

	cd "${S}"/kernel-4.9
	unipatch "${FILESDIR}"/l4t-kernel-drop-emc-optimization-flag.patch
	use kali_patches && unipatch "${FILESDIR}"/kali-wifi-injection-4.9.patch
	use kali_patches && unipatch "${FILESDIR}"/0001-wireless-carl9170-Enable-sniffer-mode-promisx-flag-t.patch
	use kali_patches && unipatch "${FILESDIR}"/usb_gadget_bashbunny_patches-l4t_4.9.patch
}

src_configure() {
	S="${WORKDIR}"/kernel/kernel-4.9
	einfo "Use provided t210_switch_defconfig"
	cd "${S}"
	cp arch/arm64/configs/t210_switch_defconfig  .config || die "copy failed"

	einfo "Prepare the kernel for build"
	emake olddefconfig || die "emake olddefconfig failed"
	unpack_set_extraversion
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
	mkdir "${D}/boot"
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake modules_install || die "emake modules_install failed"
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake install || die "make install failed"
}
