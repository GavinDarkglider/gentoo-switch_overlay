# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9"
DESCRIPTION="Nintendo Switch kernel sources (L4T 4.9, the L4T community tree)"
LICENSE="GPL-2"
SLOT="${PVR}"
IUSE="fbcondecor symlink"
RESTRICT="binchecks strip"

# The same trees, commits and patches as sys-kernel/nintendo-switch-l4t-kernel,
# so these are the sources of the kernel that package builds: fetched one by
# one and combined into one kernel tree as Lakka does.
L4T_SOURCES=(
	# place in the tree, repository, branch, commit[, the folder of it used]
	". https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9.git fedora-dev 1a6c369842f53995fab9b0416222594a7bde685e"
	"nvidia https://gitlab.com/l4t-community/kernel/switch-l4t-kernel-nvidia.git linux-6.0.0 54e79a487dc76fdcf09b98bfe4191ca7688ea021"
	"nvidia/nvgpu https://gitlab.com/switchroot/kernel/l4t-kernel-nvgpu.git linux-3.4.0-r32.5 1ae0167d360287ca78f5a2572f0de42594140312"
	"nvidia/platform/t210/nx https://gitlab.com/l4t-community/kernel/switch-l4t-platform-t210-nx.git linux-6.0.0 0eec94ae2bcfecc54d9dcaa1a0d6e71c1c88daf2"
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
	# Joy-Con MCU (tera): NFC and IR camera, from Lakka (PR #2221)
	"${FILESDIR}"/09-nintendo-tera-add-MCU-core.patch
	"${FILESDIR}"/10-nintendo-tera-add-NFC.patch
	"${FILESDIR}"/11-nintendo-tera-add-IR-camera.patch
	"${FILESDIR}"/12-HID-nintendo-wire-up-tera.patch
	"${FILESDIR}"/13-Input-joycon-serdev-wire-up-tera.patch
	"${FILESDIR}"/14-arm64-tegra_linux_defconfig-enable-tera.patch
	# backports the tera drivers need: NFC poll fix, V4L metadata capture
	"${FILESDIR}"/15-nfc-core-fix-stop_poll-refcount-leak.patch
	"${FILESDIR}"/16-media-v4l-backport-metadata-capture.patch
	# USB gadget: f_hid unbind fix, DVD-ROM emulation for mass storage
	# (CTCaer PR #9), settable ECM/RNDIS link speed (Usb_gadget_stuff)
	"${FILESDIR}"/17-f_hid-fix-cdev-use-after-free-on-unbind.patch
	"${FILESDIR}"/18-f_mass_storage-emulate-a-real-DVD-ROM.patch
	"${FILESDIR}"/19-usb-gadget-ecm-rndis-settable-bitrate.patch
	# iSCSI initiator: build fix (CTCaer PR #10) and build it as modules
	"${FILESDIR}"/20-iscsi-fix-libiscsi_tcp-build.patch
	"${FILESDIR}"/21-arm64-tegra_linux_defconfig-enable-iscsi-tcp.patch
)


# kernel 4.9.140, extraversion -p20261105-l4t-gentoo
KV_EXTRA="-${PV#*_}-l4t-gentoo"
KV_FULL="${PV%%_*}${KV_EXTRA}"
S="${WORKDIR}/linux-${KV_FULL}"

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

	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${KV_EXTRA}:" Makefile || die
	sed -i -e 's:^CONFIG_LOCALVERSION=".*:# CONFIG_LOCALVERSION is not set:g' \
		arch/arm64/configs/tegra_linux_defconfig || die
}

src_compile() { :; }

src_install() {
	dodir /usr/src
	mv "${S}" "${ED}"/usr/src/ || die
}

pkg_postinst() {
	if use symlink || [[ ! -e ${EROOT}/usr/src/linux ]]; then
		ln -snf linux-${KV_FULL} "${EROOT}"/usr/src/linux || die
	fi

	elog "Build it in /usr/src/linux-${KV_FULL}: make tegra_linux_defconfig, then"
	elog "make. make dtbs also makes arch/arm64/boot/dts/nx-plat.dtimg, the"
	elog "device trees U-Boot loads (it needs python3)."
	elog
	elog "U-Boot loads the kernel as a gzip uImage; with"
	elog "sys-kernel/installkernel[nsw], \"make install\" makes it. By hand:"
	elog "  mkimage -A arm64 -O linux -T kernel -C gzip -a 0x80200000 \\"
	elog "    -e 0x80200000 -n L4T-${KV_FULL} -d Image.gz uImage"
}
