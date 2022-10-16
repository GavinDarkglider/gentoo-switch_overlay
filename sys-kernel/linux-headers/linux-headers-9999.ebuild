# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="arm64"

NVIDIA_VER="l4t/l4t-r32.5"

inherit kernel-2 git-r3

KEYWORDS="-* arm64"

# bug #816762
RESTRICT="test"

HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"

EXTRAVERSION="-l4t-gentoo"
KV_LOCALVERSION="-l4t-gentoo-dist"

DESCRIPTION="Nintendo Switch kernel Headers"

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
	EGIT_BRANCH="linux-3.4.1-dev"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvidia"
	EGIT_BRANCH="linux-3.4.2-dev"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu/"
	EGIT_BRANCH="linux-3.4.0-r32.5"
	EGIT_CHECKOUT_DIR="${S}/nvidia/nvgpu"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-switch"
	EGIT_BRANCH="linux-3.4.1-dev"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/icosa"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-soc-tegra"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/tegra"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-soc-t210"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/soc/t210/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-tegra-common"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/tegra/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-common"
	EGIT_BRANCH="${NVIDIA_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/common/"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*
}

src_prepare() {
	eapply "${FILESDIR}"/01-unify_l4t_sources.patch
	eapply "${FILESDIR}"/02-gcc-10.patch
	eapply "${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	eapply "${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	eapply "${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch
	eapply "${FILESDIR}"/06-Revert-arm64-32bit-sigcontext-definition-to-uapi-signcontext.h.patch
	eapply "${FILESDIR}"/linux-headers-fix-no-uapi-header-provides-a-definition-of-struct-sockaddr.patch
	eapply "${FILESDIR}"/linux-headers-add-MAP_HUGE_2MB-and-MAP_HUGE_1MB.patch
	eapply_user
	default
}

#This is skipped..... do to restrict="test"
src_test() {
    einfo "Possible unescaped attribute/type usage"
    egrep -r \
        -e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
        -e '\<([us](8|16|32|64))\>' \
        .

    emake ARCH="$(tc-arch-kernel)" headers_check
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die
}
