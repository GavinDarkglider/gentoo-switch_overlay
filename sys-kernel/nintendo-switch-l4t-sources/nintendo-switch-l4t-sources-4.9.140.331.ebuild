# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
ETYPE="sources"

SWITCHROOT_VER="linux-3.3.1"
NVIDIA_VER="l4t/l4t-r32.3.1"

DEPEND="sys-apps/dtc"

inherit kernel-2 git-r3
detect_version
detect_arch

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
IUSE=""

EXTRAVERSION="l4t-switchroot"

DESCRIPTION="Nintendo Switch kernel sources"
SRC_URI="${GENPATCHES_URI} ${ARCH_URI}"

S="${WORKDIR}"/linux-"${PVR}"-"${EXTRAVERSION}"

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*
	
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvidia"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/linux-nvgpu"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/nvgpu"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-switch"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/icosa"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/soc/tegra"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/tegra"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/soc/t210"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/t210/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/platform/tegra/common"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/tegra/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="git://nv-tegra.nvidia.com/device/hardware/nvidia/platform/t210/common"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*
}

src_prepare() {
	eapply "${FILESDIR}"/unify-kernel.patch
	eapply "${FILESDIR}"/331_gcc-10.patch
	eapply "${FILESDIR}"/d97aaee81dc4b82595dc90ccb6a29bb0de3669d4.patch
	eapply "${FILESDIR}"/50dec8298041f5b25d4df112e6108056a7e34526.patch
	eapply "${FILESDIR}"/ac1447bfc5b10ab2a449551da507bcaeec9cfb68.patch
	eapply_user
}
	
src_configure() {
	einfo "Adjust extraversion to ${EXTRAVERSION}"
	unpack_set_extraversion
}


pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
