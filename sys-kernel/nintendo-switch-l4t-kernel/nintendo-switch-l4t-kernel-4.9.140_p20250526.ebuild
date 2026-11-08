# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9"
IUSE="debug"

KV_LOCALVERSION="-l4t-gentoo-dist"

DESCRIPTION="Nintendo Switch kernel (L4T 4.9, the L4T community tree)"

inherit kernel-build git-r3

# The L4T community (Azkali) tree as the L4S pipeline lays it out
# (scripts/kernel/kernel.sh): the kernel, with nvidia, nvgpu and the
# device trees next to it. Pinned to fedora-stable and the commits of
# the other trees that go with it (nvidia linux-5.1.2, the nx device
# trees of the same day); their newer heads need fedora-dev.
S="${WORKDIR}"/kernel-4.9

L4T_SOURCES=(
	# folder repository branch commit
	"kernel-4.9 https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9.git fedora-stable 9e6b7f8fe17fa67b3563eae39e52ee0bd8cd1f3a"
	"nvidia https://gitlab.com/l4t-community/kernel/switch-l4t-kernel-nvidia.git linux-5.1.2 ed735c6dc5ceb52c4fcadc77e100ebede5bdd495"
	"nvgpu https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu.git linux-3.4.0-r32.5 1ae0167d360287ca78f5a2572f0de42594140312"
	"hardware/nvidia/platform/t210/nx https://gitlab.com/l4t-community/kernel/switch-l4t-platform-t210-nx.git linux-6.0.0 feb8a200378e49a2a3327a212a9a0ea6cc265199"
	"hardware/nvidia/soc/t210 https://gitlab.com/switchroot/kernel/l4t-soc-t210.git l4t/l4t-r32.5 0d7816046cb06b637a3b70381a5e4994fd897c35"
	"hardware/nvidia/soc/tegra https://gitlab.com/switchroot/kernel/l4t-soc-tegra.git l4t/l4t-r32.5 d2692b96d3a89e26d3bad94eb7e6bc4caccbdbdb"
	"hardware/nvidia/platform/tegra/common https://gitlab.com/switchroot/kernel/l4t-platform-tegra-common.git l4t/l4t-r32.5 1677f40a0b1bfa7c7273143b0f4944de28b73444"
	"hardware/nvidia/platform/t210/common https://gitlab.com/switchroot/kernel/l4t-platform-t210-common.git l4t/l4t-r32.5 846ce66ee941b49ff32bc721e4c8cc99eea2e979"
)

# What Lakka builds its L4T kernels with (packages/linux/package.mk):
# warnings newer gcc versions turn into errors in this kernel
L4T_KCFLAGS="-Wno-stringop-truncation -Wno-error=stringop-overflow -Wno-maybe-uninitialized
	-Wno-address-of-packed-member -Wno-packed-not-aligned -Wno-array-bounds -Wno-error=address
	-Wno-error=stringop-overread"

src_unpack() {
	local source folder
	for source in "${L4T_SOURCES[@]}"; do
		read -r folder EGIT_REPO_URI EGIT_BRANCH EGIT_COMMIT <<< "${source}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${folder}"
		git-r3_src_unpack
		rm -rf "${EGIT_CHECKOUT_DIR}"/.git* || die
	done
}

src_prepare() {
	# fixes from meta-tegra for the nvidia drivers and the GIC, and the
	# hdlc_x25 settings (paths from ${WORKDIR})
	pushd "${WORKDIR}" >/dev/null || die
	eapply "${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	eapply "${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	popd >/dev/null || die
	eapply "${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch
	eapply "${FILESDIR}"/06-add_wan_hdlc_x25.patch

	emake ARCH=arm64 tegra_linux_defconfig
	local extraversion="-$(dist-kernel_PV_to_KV "${PV}" | cut -d- -f2-)${KV_LOCALVERSION}"
	einfo "Set extraversion to ${extraversion}, and no localversion"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${extraversion}:" Makefile || die
	sed -i -e 's:^CONFIG_LOCALVERSION=".*:# CONFIG_LOCALVERSION is not set:g' .config || die

	eapply_user
}

src_configure() {
	export KCFLAGS="${KCFLAGS} ${L4T_KCFLAGS//$'\n'/ }"
	# where the device trees are (scripts/Kbuild.include; the default is
	# NVIDIA's layout, two folders up)
	export NV_BUILD_KERNEL_DTS_ROOT="${WORKDIR}/hardware/nvidia"
	kernel-build_src_configure
}

src_compile() {
	export LDFLAGS="" # Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	kernel-build_src_compile
}

ver="$(dist-kernel_PV_to_KV "${PV}")${KV_LOCALVERSION}"
inst_path=/usr/src/linux-${ver}/arch/arm64/boot

src_install() {
	kernel-build_src_install

	einfo "Install dtb files"
	cd "${WORKDIR}"/build/arch/arm64/boot/dts || die
	insinto "${inst_path}"/dts
	doins *.dtb

	einfo "Add version to firmware files to avoid file collisions"
	local f
	for f in ttusb-budget/dspbootcode.bin brcm/brcmfmac4356A3-pcie.bin brcm/BCM4356A3.hcd; do
		mv -v "${D}"/lib/firmware/${f} "${D}"/lib/firmware/${f}-"${ver}" || die
	done
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
