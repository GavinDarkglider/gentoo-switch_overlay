# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

NVIDIA_VER="32.1"

KEYWORDS="~arm64"
SLOT="${NVIDIA_VER}"

HOMEPAGE="https://gitlab.com/switchroot/
	https://nv-tegra.nvidia.com/gitweb"

IUSE="lakka_patches"

DESCRIPTION="Nintendo Switch Linux kernel DTS-Tree"

inherit git-r3

S="${WORKDIR}/${PN}-${NVIDIA_VER}"

inherit epatch

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvidia"
	EGIT_BRANCH="rel32-rel32stack"
#	EGIT_BRANCH="rel32-android"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/linux-nvgpu.git"
	EGIT_BRANCH="l4t/l4t-r${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvgpu"
	git-r3_src_unpack

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-switch"
	EGIT_BRANCH="rel-30-r3"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/t210/switch"
	git-r3_src_unpack

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/soc/tegra.git"
	EGIT_BRANCH="l4t/l4t-r${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/soc/tegra"
	git-r3_src_unpack

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/soc/t210.git"
	EGIT_BRANCH="l4t/l4t-r${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/soc/t210/"
	git-r3_src_unpack

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/platform/tegra/common.git"
	EGIT_BRANCH="l4t/l4t-r${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/tegra/common/"
	git-r3_src_unpack

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/platform/t210/common.git"
	EGIT_BRANCH="l4t/l4t-r${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/hardware/nvidia/platform/t210/common/"
	git-r3_src_unpack

# Patches to /hardware/nvidia/platform/t210/switch
	cd "${S}"/hardware/nvidia/platform/t210/switch
	if use lakka_patches; then
		einfo "Apply Lakka patches"
		# Source: https://github.com/lakka-switch/Lakka-LibreELEC/tree/master/projects/Switch/devices/L4T/packages/l4t-kernel/patches
		epatch "${FILESDIR}"/l4t-platform-t210-switch-0001-jc-pinmux.patch
		epatch "${FILESDIR}"/l4t-platform-t210-switch-0002-jc-driver.patch

		ewarn "Lakka Patches Break Sleep Mode."
		ewarn "This will be added to default build"
		ewarn "when this issue is fixed."
	fi

}

src_install() {
	dodir /usr/src/
	insinto /usr/src/
	doins -r "${S}"
	dobin "${FILESDIR}"/make-with-dts-"${NVIDIA_VER}".sh
	einfo "use this device tree by compiling your kernel with make-with-dts-${NVIDIA_VER}.sh"
	einfo "Note only the kernels are supported placed to /usr/src/nintendo-switch-l4t-dtstree-${NVIDIA_VER}"
}
