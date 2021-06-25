# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

SWITCHROOT_VER="linux-3.3.1"
NVIDIA_VER="l4t/l4t-r32.3.1"
EXTRAVERSION=".331-l4t-gentoo-dist"
KV_LOCALVERSION="-l4t-gentoo-dist"

inherit kernel-build git-r3

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
IUSE="+initramfs "

DESCRIPTION="Nintendo Switch kernel"
SRC_URI=""

RDEPEND="sys-kernel/linux-firmware[switch_mod]
        initramfs? ( sys-boot/nintendo-switch-dracut-config dev-embedded/u-boot-tools )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/linux-"${PVR}"

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

	make tegra_linux_defconfig
	einfo "Adjust extraversion to ${EXTRAVERSION} and localversion to ${KV_LOCALVERSION}"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" "${S}"/Makefile || die
	eapply_user
}


src_compile() {
	# Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	export LDFLAGS=""
	kernel-build_src_compile
}

src_install() {
	kernel-build_src_install
	cd "${WORKDIR}"/build
	insinto "/boot"
	newins arch/arm64/boot/dts/tegra210-icosa.dtb tegra210-icosa-"${PVR}${KV_LOCALVERSION}".dtb
}

pkg_postinst() {
	kernel-install_pkg_postinst
	if [[ -z ${ROOT} ]]; then
		local ver="${PVR}${KV_LOCALVERSION}"
		mv "vmlinuz-${ver}" "vmlinuz-${ver}".gz
		gunzip "vmlinuz-${ver}".gz
		[[ -e "${EROOT}/boot/Image" ]] || ln -v -s "vmlinuz-${ver}" "${EROOT}/boot/Image"
		[[ -e "${EROOT}/boot/tegra210-icosa.dtb" ]] || ln -v -s "tegra210-icosa-${ver}".dtb "${EROOT}/boot/tegra210-icosa.dtb"
		if use initramfs; then
			local inst_path=/usr/src/linux-${ver}/arch/arm64/boot
			einfo "Generate u-boot image ${inst_path}/initramfs from generated ${inst_path}/initrd"
			mkimage -A arm64 -O linux -T ramdisk -C gzip -d "${EROOT}${inst_path}/initrd" "${EROOT}${inst_path}/initramfs"
			cp "${EROOT}${inst_path}/initramfs" "${EROOT}/boot/initramfs-${ver}"
			[[ -e "${EROOT}/boot/initramfs" ]] || ln -v -s "initramfs-${ver}" "${EROOT}/boot/initramfs"
		fi
	fi
}

pkg_config() {
	pkg_postinst
}
