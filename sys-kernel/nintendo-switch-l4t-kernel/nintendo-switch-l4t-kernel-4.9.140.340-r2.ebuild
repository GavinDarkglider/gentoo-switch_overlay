# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

SWITCHROOT_VER="linux-3.4.0"
NVIDIA_VER="l4t/l4t-r32.5"

EXTRAVERSION=".340-l4t-gentoo-dist"
KV_LOCALVERSION="-l4t-gentoo-dist"

inherit kernel-build git-r3

ver="${PV}${KV_LOCALVERSION}"

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
IUSE="+initramfs "

DESCRIPTION="Nintendo Switch kernel"
SRC_URI=""

RDEPEND="sys-kernel/linux-firmware[switch_mod]
        initramfs? ( sys-boot/nintendo-switch-dracut-config dev-embedded/u-boot-tools )"
DEPEND="${RDEPEND}
		!=sys-kernel/nintendo-switch-l4t-kernel-4.9.140.331"

S="${WORKDIR}"/linux-"${PVR}"

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
	EGIT_COMMIT="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvidia"
	EGIT_COMMIT="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}/nvidia"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu/"
	EGIT_BRANCH="${SWITCHROOT_VER}-r32.5"
	unset EGIT_COMMIT
	EGIT_CHECKOUT_DIR="${S}/nvidia/nvgpu"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-platform-t210-switch"
	EGIT_COMMIT="${SWITCHROOT_VER}"
	unset EGIT_BRANCH
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/icosa"
	git-r3_src_unpack
	rm -Rf "${EGIT_CHECKOUT_DIR}"/.git*

	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-soc-tegra"
	EGIT_BRANCH="${NVIDIA_VER}"
	unset EGIT_COMMIT
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
	eapply "${FILESDIR}"/unify-kernel.patch
	eapply "${FILESDIR}"/340_gcc-10.patch
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
	export KCFLAGS="-Wno-error=stringop-overread" # GCC-11 support
	kernel-build_src_compile
}

src_install() {
	kernel-build_src_install

	einfo "Add version to firmware files"
	mv -v "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/brcmfmac4356-pcie.bin "${D}"/lib/firmware/brcm/brcmfmac4356-pcie.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/BCM4356A3.hcd "${D}"/lib/firmware/brcm/BCM4356A3.hcd-"${ver}"

	cd "${WORKDIR}"/build
	insinto "/boot"
	newins arch/arm64/boot/dts/tegra210-icosa.dtb tegra210-icosa.dtb-"${ver}"
}

_symlink_version() {
	FILE="$1"
	if [[ -L "${EROOT}${FILE}" ]]; then
		rm -v "${EROOT}${FILE}"
	elif [[ -e "${EROOT}${FILE}" ]]; then
		mv -v "${EROOT}${FILE}" "${EROOT}${FILE}".old
	fi
	ln -v -s "$(basename "${FILE}")"-"${ver}" "${EROOT}${FILE}"
}

pkg_postinst() {
	kernel-install_pkg_postinst
	if [[ -z ${ROOT} ]]; then
		#extract the kernel
		mv "${EROOT}/boot/vmlinuz-${ver}" "${EROOT}/boot/Image-${ver}".gz
		gunzip "${EROOT}/boot/Image-${ver}".gz

		# update Image and DTB symlink
		_symlink_version "/boot/Image"
		_symlink_version "/boot/tegra210-icosa.dtb"
		_symlink_version "/lib/firmware/ttusb-budget/dspbootcode.bin"
		_symlink_version "/lib/firmware/brcm/brcmfmac4356-pcie.bin"
		_symlink_version "/lib/firmware/brcm/BCM4356A3.hcd"

		if use initramfs; then
			# pack initramfs to u-boot image
			local inst_path=/usr/src/linux-${ver}/arch/arm64/boot
			einfo "Generate u-boot image ${inst_path}/initramfs from generated ${inst_path}/initrd"
			mkimage -A arm64 -O linux -T ramdisk -C gzip -d "${EROOT}${inst_path}/initrd" "${EROOT}${inst_path}/initramfs"
			cp "${EROOT}${inst_path}/initramfs" "${EROOT}/boot/initramfs-${ver}"

			# remove initramfs.img, installed by framework
			rm "${EROOT}/boot/initramfs-${ver}".img

			_symlink_version "/boot/initramfs"
		fi
	fi
}

_check_symlink() {
	FILE="$1"
	if [[ -h "${EROOT}${FILE}" && ! -e "${EROOT}${FILE}" ]] ; then
		einfo "fix broken symlink ${FILE}"
		NEWTARGET="$(ls -1 "$FILE"-* 2>/dev/null | tail -n1)"
		rm "${EROOT}${FILE}"
		ln -v -s "$(basename "${NEWTARGET}")"-"${ver}" "${EROOT}${FILE}"
    fi
}

pkg_postrm() {
	_check_symlink "/boot/Image"
	_check_symlink "/boot/tegra210-icosa.dtb" "tegra210-icosa-"
	_check_symlink "/lib/firmware/ttusb-budget/dspbootcode.bin"
	_check_symlink "/lib/firmware/brcm/brcmfmac4356-pcie.bin"
	_check_symlink "/lib/firmware/brcm/BCM4356A3.hcd"
}

pkg_config() {
	pkg_postinst
}
