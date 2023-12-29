# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"

KEYWORDS="-* arm64"
HOMEPAGE="https://github.com/CTCaer/switch-l4t-kernel-4.9"
IUSE="+initramfs debug"

ADD_VERSION=512
KV_LOCALVERSION="-l4t-gentoo-dist"

DESCRIPTION="Nintendo Switch kernel"

inherit kernel-build git-r3

DEPEND="initramfs? ( sys-libs/gentoo-config-files[initramfs] dev-embedded/u-boot-tools )
   =sys-kernel/installkernel-gentoo-999-r3"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/linux-"${PVR}"

src_unpack() {
	EGIT_REPO_URI="https://github.com/CTCaer/switch-l4t-kernel-4.9"
	EGIT_BRANCH=""
	EGIT_TAG="linux-5.1.2"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*

	EGIT_REPO_URI="https://github.com/CTCaer/switch-l4t-kernel-nvidia"
	EGIT_BRANCH=""
	EGIT_TAG="linux-5.1.2"
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
	EGIT_TAG="linux-5.1.2"
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
	eapply "${FILESDIR}"/02-gcc-12-4.9.140.511.patch
	eapply "${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	eapply "${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	eapply "${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch

	emake tegra_linux_defconfig
	EXTRAVERSION=".${ADD_VERSION}${KV_LOCALVERSION}"
	einfo "Adjust extraversion to ${EXTRAVERSION} and reset localversion"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" "${S}"/Makefile || die
	sed -i -e 's:^CONFIG_LOCALVERSION=".*:# CONFIG_LOCALVERSION is not set:g' .config || die

	eapply_user
}

src_compile() {
	export LDFLAGS="" # Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	kernel-build_src_compile
}

ver="${PV}${KV_LOCALVERSION}"
inst_path=/usr/src/linux-${ver}/arch/arm64/boot

src_install() {
	kernel-build_src_install

	einfo "Install dtb files"
	cd "${WORKDIR}"/build/arch/arm64/boot/dts
	insinto "${inst_path}"/dts
	for dts in *.dtb; do
		doins "${dts}"
	done

	einfo "Add version to firmware files to avoid file collisions"
	mv -v "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin "${D}"/lib/firmware/ttusb-budget/dspbootcode.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/brcmfmac4356A3-pcie.bin "${D}"/lib/firmware/brcm/brcmfmac4356A3-pcie.bin-"${ver}"
	mv -v "${D}"/lib/firmware/brcm/BCM4356A3.hcd "${D}"/lib/firmware/brcm/BCM4356A3.hcd-"${ver}"
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
	_check_symlink "/lib/firmware/ttusb-budget/dspbootcode.bin"
	_check_symlink "/lib/firmware/brcm/brcmfmac4356A3-pcie.bin"
	_check_symlink "/lib/firmware/brcm/BCM4356A3.hcd"
}

pkg_config() {
	pkg_postinst
}
