# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9"
IUSE="debug fbcondecor"

KV_LOCALVERSION="-l4t-gentoo-dist"

DESCRIPTION="Nintendo Switch kernel (L4T 4.9, the L4T community tree)"

inherit kernel-build git-r3

# The L4T community (Azkali) L4T 4.9 tree: fedora-stable and the commits of
# the other trees that go with it (nvidia linux-5.1.2, the nx device trees
# of the same day; their newer heads need fedora-dev). Each tree is fetched
# on its own and they are combined into one kernel tree as Lakka does
# (scripts/get_l4t-kernel-sources), with its unify patch.
S="${WORKDIR}"/linux-${PV}

L4T_SOURCES=(
	# place in the tree, repository, branch, commit[, the folder of it used]
	". https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9.git fedora-stable 9e6b7f8fe17fa67b3563eae39e52ee0bd8cd1f3a"
	"nvidia https://gitlab.com/l4t-community/kernel/switch-l4t-kernel-nvidia.git linux-5.1.2 ed735c6dc5ceb52c4fcadc77e100ebede5bdd495"
	"nvidia/nvgpu https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu.git linux-3.4.0-r32.5 1ae0167d360287ca78f5a2572f0de42594140312"
	"nvidia/platform/t210/nx https://gitlab.com/l4t-community/kernel/switch-l4t-platform-t210-nx.git linux-6.0.0 feb8a200378e49a2a3327a212a9a0ea6cc265199"
	"nvidia/platform/t210/common https://gitlab.com/switchroot/kernel/l4t-platform-t210-common.git l4t/l4t-r32.5 846ce66ee941b49ff32bc721e4c8cc99eea2e979"
	"nvidia/platform/tegra/common https://gitlab.com/switchroot/kernel/l4t-platform-tegra-common.git l4t/l4t-r32.5 1677f40a0b1bfa7c7273143b0f4944de28b73444"
	"nvidia/soc/t210/kernel-dts https://gitlab.com/switchroot/kernel/l4t-soc-t210.git l4t/l4t-r32.5 0d7816046cb06b637a3b70381a5e4994fd897c35 kernel-dts"
	"nvidia/soc/tegra/kernel-include https://gitlab.com/switchroot/kernel/l4t-soc-tegra.git l4t/l4t-r32.5 d2692b96d3a89e26d3bad94eb7e6bc4caccbdbdb kernel-include"
)

PATCHES=(
	# the combined tree (Lakka's, projects/L4T/devices/Switch/patches)
	"${FILESDIR}"/01-unify_l4t_sources.patch
	# Lakka's warning flags in the Makefile, so a plain make builds it
	"${FILESDIR}"/02-l4t_gcc_warnings.patch
	# fixes from meta-tegra for the nvidia drivers and the GIC
	"${FILESDIR}"/03-nvidia_drivers_actmon_add__init_annotation_to_tegra_actmon_register.patch
	"${FILESDIR}"/04-nvidia_drivers_eventlib_use_existing_kernel_sync_bitops.patch
	"${FILESDIR}"/05_irq_gic_drop__init_annotation_from_gic_init_fiq.patch
	"${FILESDIR}"/06-add_wan_hdlc_x25.patch
	# make dtbs also makes nx-plat.dtimg, which U-Boot loads
	"${FILESDIR}"/07-nx_plat_dtimg.patch
)

src_unpack() {
	local source place used
	for source in "${L4T_SOURCES[@]}"; do
		read -r place EGIT_REPO_URI EGIT_BRANCH EGIT_COMMIT used <<< "${source}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/l4t-git/${place//\//_}"
		[[ ${place} == . ]] && EGIT_CHECKOUT_DIR="${WORKDIR}/l4t-git/kernel"
		git-r3_src_unpack
		mkdir -p "${S}/${place}" || die
		cp -a "${EGIT_CHECKOUT_DIR}/${used:-.}"/. "${S}/${place}"/ || die
	done
	rm -rf "${WORKDIR}"/l4t-git || die
	find "${S}" -name '.git*' -prune -exec rm -rf {} + || die
}

src_prepare() {
	# framebuffer console decorations (splashutils), on in the defconfig
	use fbcondecor && PATCHES+=( "${FILESDIR}"/08-fbcondecor.patch )

	default

	if use fbcondecor; then
		echo "CONFIG_FB_CON_DECOR=y" >> arch/arm64/configs/tegra_linux_defconfig || die
	fi

	emake ARCH=arm64 tegra_linux_defconfig
	local extraversion="-$(dist-kernel_PV_to_KV "${PV}" | cut -d- -f2-)${KV_LOCALVERSION}"
	einfo "Set extraversion to ${extraversion}, and no localversion"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${extraversion}:" Makefile || die
	sed -i -e 's:^CONFIG_LOCALVERSION=".*:# CONFIG_LOCALVERSION is not set:g' .config || die
}

src_compile() {
	export LDFLAGS="" # Workaround: /usr/bin/ld: unrecognized option '-Wl,-O1'
	# the Python kernel-build set up, for scripts/mkdtboimg.py
	export NX_DTIMG_PYTHON="${EPYTHON}"
	kernel-build_src_compile
}

ver="$(dist-kernel_PV_to_KV "${PV}")${KV_LOCALVERSION}"
inst_path=/usr/src/linux-${ver}/arch/arm64/boot

src_install() {
	kernel-build_src_install

	einfo "Install dtb files"
	cd "${WORKDIR}"/build/arch/arm64/boot/dts || die
	insinto "${inst_path}"/dts
	doins *.dtb nx-plat.dtimg

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
