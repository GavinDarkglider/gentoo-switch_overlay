# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

SLOT="32.2"
CMSHIELD_VER="lineage-16.0"
SWITCHROOT_VER="linux-rel32"

KEYWORDS="arm64"

HOMEPAGE="https://gitlab.com/switchroot/
	https://nv-tegra.nvidia.com/gitweb"

IUSE="emmc_access"

DESCRIPTION="Nintendo Switch Linux kernel DTS-Tree"

inherit git-r3

S="${WORKDIR}/${PN}-${SLOT}"

inherit epatch

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvidia"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.incom.co/CM-Shield/android_kernel_nvidia_linux-4.9_kernel_nvgpu"
	EGIT_BRANCH="${CMSHIELD_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvgpu"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-switch"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/t210/icosa"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.incom.co/CM-Shield/android_kernel_nvidia_linux-4.9_hardware_nvidia_soc_tegra"
	EGIT_BRANCH="${CMSHIELD_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/soc/tegra"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.incom.co/CM-Shield/android_kernel_nvidia_linux-4.9_hardware_nvidia_soc_t210"
	EGIT_BRANCH="${CMSHIELD_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/soc/t210/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.incom.co/CM-Shield/android_kernel_nvidia_linux-4.9_hardware_nvidia_platform_tegra_common"
	EGIT_BRANCH="${CMSHIELD_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/tegra/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.incom.co/CM-Shield/android_kernel_nvidia_linux-4.9_hardware_nvidia_platform_t210_common"
	EGIT_BRANCH="${CMSHIELD_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/t210/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*
}

src_prepare() {
	if use emmc_access; then
		ewarn "**** emms access is enabled, the emms will be mmcblk0 and the SD-card moves to mmcblk1 so you need to update your config files"
		ewarn "**** Be careful and do not break your device. Do it on your own risk-"
		cd "${S}/hardware/nvidia/platform/t210/icosa"
		eapply "${FILESDIR}/emmc_enable-${SLOT}.patch"
	fi
	cd "${S}"
	eapply_user
}

src_install() {
	dodir /usr/src/
	insinto /usr/src/
	doins -r "${S}"
	dobin "${FILESDIR}"/make-with-dts-"${SLOT}".sh
	einfo "use this device tree by compiling your kernel with make-with-dts-${SLOT}.sh"
	einfo "Note only the kernels are supported placed to /usr/src/nintendo-switch-l4t-dtstree-${SLOT}"
}
