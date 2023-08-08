# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"

inherit kernel-2 git-r3
detect_version
detect_arch

KEYWORDS="-* arm64"
HOMEPAGE="https://github.com/CTCaer/switch-l4t-kernel-4.9"
IUSE=""

ADD_VERSION=510

EXTRAVERSION="-l4t-gentoo"

DESCRIPTION="Nintendo Switch kernel sources"

S="${WORKDIR}"/linux-"${PVR}""${EXTRAVERSION}"

src_unpack() {
	EGIT_REPO_URI="https://github.com/CTCaer/switch-l4t-kernel-4.9"
	EGIT_BRANCH=""
	EGIT_TAG="linux-5.1.0_r2"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*

	EGIT_REPO_URI="https://github.com/CTCaer/switch-l4t-kernel-nvidia"
	EGIT_BRANCH=""
	EGIT_TAG="linux-5.1.0"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu/"
	EGIT_BRANCH="linux-3.4.0-r32.5"
	EGIT_TAG=""
	EGIT_CHECKOUT_DIR="${S}/nvidia/nvgpu"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://github.com/CTCaer/switch-l4t-platform-t210-nx"
	EGIT_BRANCH=""
	EGIT_TAG="linux-5.1.0"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/nx"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-soc-tegra"
	EGIT_BRANCH="l4t/l4t-r32.5"
	EGIT_TAG=""
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/tegra"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-soc-t210"
	EGIT_BRANCH="l4t/l4t-r32.5"
	EGIT_TAG=""
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/t210/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-tegra-common"
	EGIT_BRANCH="l4t/l4t-r32.5"
	EGIT_TAG=""
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/tegra/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-common"
	EGIT_BRANCH="l4t/l4t-r32.5"
	EGIT_TAG=""
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*
}

src_prepare() {
	eapply "${FILESDIR}"/01-unify_l4t_sources.patch
	eapply "${FILESDIR}"/02-gcc-10-4.9.140.510.patch
	eapply "${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	eapply "${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	eapply "${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch
	eapply_user
}

src_configure() {
	EXTRAVERSION=".${ADD_VERSION}${EXTRAVERSION}"
	einfo "Adjust EXTRAVERSION to ${EXTRAVERSION} and reset LOCALVERSION in tegra_linux_defconfig"
	unpack_set_extraversion
	sed -i -e 's:^CONFIG_LOCALVERSION=".*:# CONFIG_LOCALVERSION is not set:g' arch/arm64/configs/tegra_linux_defconfig || die
}


pkg_postinst() {
	kernel-2_pkg_postinst
	echo""
	einfo "Hekate L4T loader requires DTimage file nx-plat.dtimg to be made with mkdtboimg."
	einfo "Proper command for making dtimage:"
	einfo "# mkdtboimg.py create nx-plat.dtimg --page_size=1000 \\"
	einfo "    tegra210-odin.dtb --id=0x4F44494E \\"
	einfo "    tegra210b01-odin.dtb --id=0x4F44494E --rev=0x00000b01 \\"
	einfo "    tegra210b01-vali.dtb --id=0x56414C49 \\"
	einfo "    tegra210b01-frig.dtb --id=0x46524947"
	echo ""
	einfo "Kernel Image file needs to be compressed GZ uimage."
	einfo "Proper command  for creating GZ compressed kernel image:"
	einfo "# gzip Image; mkimage -A arm64 -O linux -T kernel -C gzip \\"
	einfo "    -a 0x80200000 -e 0x80200000 -n CTCKRN-5.0.0 -d Image.gz Image; rm Image.gz"
	echo ""
	einfo "if =sys-kernel/installkernel-gentoo-999 is installed, the \"make install\" do both for you."
	echo ""
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
