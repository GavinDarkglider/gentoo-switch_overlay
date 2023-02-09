# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

NVIDIA_VER="l4t/l4t-r32.3.1"

EXTRAVERSION=".341-l4t-gentoo-dist"
KV_LOCALVERSION="-l4t-gentoo-dist"

inherit kernel-build git-r3

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
IUSE="+initramfs debug"

DESCRIPTION="Nintendo Switch kernel"
SRC_URI=""

DEPEND="initramfs? ( sys-libs/gentoo-config-files[initramfs] dev-embedded/u-boot-tools )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/linux-"${PVR}"

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
	EGIT_CHECKOUT_DIR="${S}/nvidia/platform/t210/nx"
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
	# https://github.com/GavinDarkglider/Lakka-LibreELEC/tree/Lakka-v5.x-Switch/projects/L4T/devices/Switch/patches/l4t-kernel-sources
	eapply "${FILESDIR}"/01-unify_l4t_sources.patch
	eapply "${FILESDIR}"/02-gcc-10.patch
	eapply "${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	eapply "${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	eapply "${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch
	eapply "${FILESDIR}"/06-Revert-arm64-32bit-sigcontext-definition-to-uapi-signcontext.h.patch
	eapply "${FILESDIR}"/linux-headers-fix-no-uapi-header-provides-a-definition-of-struct-sockaddr.patch
	eapply "${FILESDIR}"/linux-headers-add-MAP_HUGE_2MB-and-MAP_HUGE_1MB.patch

	make tegra_linux_defconfig
	einfo "Adjust extraversion to ${EXTRAVERSION} and reset localversion"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" "${S}"/Makefile || die
	sed -i -e 's#^CONFIG_LOCALVERSION=".*#""#p' .config || die

	eapply_user
}

src_compile() {
	# Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	export LDFLAGS=""
	export KCFLAGS="-Wno-error=stringop-overread" # GCC-11 support
	export KCFLAGS+=" -Wno-error=address" # GCC-12 support
	kernel-build_src_compile
}

ver="${PV}${KV_LOCALVERSION}"
inst_path=/usr/src/linux-${ver}/arch/arm64/boot

src_install() {
	kernel-build_src_install

	einfo "Add version to firmware files"
	mv -v "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/brcmfmac4356A3-pcie.bin "${D}"/lib/firmware/brcm/brcmfmac4356A3-pcie.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/BCM4356A3.hcd "${D}"/lib/firmware/brcm/BCM4356A3.hcd-"${ver}"

	cd "${WORKDIR}"/build/arch/arm64/boot/dts
        ${FILESDIR}/mkdtboimg.py create nx-plat.dtimg --page_size=1000 \
          tegra210-odin.dtb --id=0x4F44494E \
          tegra210b01-odin.dtb --id=0x4F44494E --rev=0x00000b01 \
          tegra210b01-vali.dtb --id=0x56414C49 \
          tegra210b01-frig.dtb --id=0x46524947
	insinto "${inst_path}"/dts
	newins nx-plat.dtimg nx-plat.dtimg
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
		[[ -f "${EROOT}/boot/Image-${ver}" ]] && mv -v "${EROOT}/boot/Image-${ver}" "${EROOT}/boot/Image-${ver}".old
		mv "${EROOT}/boot/vmlinuz-${ver}" "${EROOT}/boot/Image-${ver}".gz
		gunzip "${EROOT}/boot/Image-${ver}".gz || die

		# Install dts
		[[ -f "${EROOT}"/boot/tegra210-odin.dtb-"${ver}" ]] && mv -v "${EROOT}"/boot/tegra210-odin.dtb-"${ver}" "${EROOT}"/boot/tegra210-odin.dtb-"${ver}".old
		cp -v "${EROOT}${inst_path}"/dts/tegra210-odin.dtb "${EROOT}"/boot/tegra210-odin.dtb-"${ver}"

		# update Image and DTB symlink
		_symlink_version "/boot/Image"
		_symlink_version "/boot/tegra210-odin.dtb"

		if use initramfs; then
			# pack initramfs to u-boot image
			einfo "Generate u-boot image ${inst_path}/initramfs from generated ${inst_path}/initrd"
			mkimage -A arm64 -O linux -T ramdisk -C gzip -d "${EROOT}${inst_path}/initrd" "${EROOT}${inst_path}/initramfs"
			cp "${EROOT}${inst_path}/initramfs" "${EROOT}/boot/initramfs-${ver}"

			# remove initramfs.img, installed by framework
			rm "${EROOT}/boot/initramfs-${ver}".img

			_symlink_version "/boot/initramfs"
		fi
	fi

	_symlink_version "/lib/firmware/ttusb-budget/dspbootcode.bin"
	_symlink_version "/lib/firmware/brcm/brcmfmac4356A3-pcie.bin"
	_symlink_version "/lib/firmware/brcm/BCM4356A3.hcd"
}

_check_symlink() {
	FILE="$1"
	if [[ -h "${EROOT}${FILE}" && ! -e "${EROOT}${FILE}" ]] ; then
		einfo "fix broken symlink ${FILE}"
		NEWTARGET="$(ls -1 "$FILE"-* 2>/dev/null | tail -n1)"
		rm "${EROOT}${FILE}"
		if [[ -n "${NEWTARGET}" ]]; then
			ln -v -s "$(basename "${NEWTARGET}")"-"${ver}" "${EROOT}${FILE}"
		fi
    fi
}

pkg_postrm() {

	if [[ -z ${ROOT} ]]; then
		_check_symlink "/boot/Image"
		_check_symlink "/boot/tegra210-odin.dtb" "tegra210-odin-"
	fi
	_check_symlink "/lib/firmware/ttusb-budget/dspbootcode.bin"
	_check_symlink "/lib/firmware/brcm/brcmfmac4356A3-pcie.bin"
	_check_symlink "/lib/firmware/brcm/BCM4356A3.hcd"
}

pkg_config() {
	pkg_postinst
}
