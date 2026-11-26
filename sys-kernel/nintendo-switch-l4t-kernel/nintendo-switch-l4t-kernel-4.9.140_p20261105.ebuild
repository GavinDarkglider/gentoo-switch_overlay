# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"

KEYWORDS="-* arm64"
HOMEPAGE="https://gitlab.com/l4t-community/kernel/l4t-kernel-4.9"
IUSE="debug fbcondecor live +splash"

# fbcondecor needs splashutils to draw anything; -splash leaves it out
RDEPEND="fbcondecor? ( splash? ( media-gfx/splashutils[fbcondecor(+)] ) )"
# the live initramfs, built before the kernel and built into it
DEPEND="live? ( sys-kernel/nintendo-switch-live-initramfs )"

KV_LOCALVERSION="-l4t-gentoo-dist"

DESCRIPTION="Nintendo Switch kernel (L4T 4.9, the L4T community tree)"

inherit kernel-build git-r3

# The initramfs is made by installkernel's dracut (or ugrd) plugin, inside
# the Switch system (on the Switch, or in an emulator of it: Porthole does
# that), and boot.scr needs one: the system needs that generator whatever
# USE=initramfs says. kernel-install's own USE=initramfs (on by default)
# only adds it as IDEPEND, which a cross build puts on the computer it
# builds on; the Switch profile turns it off for that reason.
RDEPEND+="
	|| (
		sys-kernel/installkernel[dracut(-)]
		sys-kernel/installkernel[ugrd(-)]
	)
"

# The L4T community (Azkali) L4T 4.9 tree: fedora-dev, with the heads of
# nvidia linux-6.0.0 and the nx device trees, which rotate the panel to
# landscape in the display controller (Xorg sees a 1280x720 panel) and turn
# the boot console with it. Each tree is fetched
# on its own and they are combined into one kernel tree as Lakka does
# (scripts/get_l4t-kernel-sources), with its unify patch.
S="${WORKDIR}"/linux-${PV}

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

	if use live; then
		# the initramfs in the kernel, and what it needs built in (it has no
		# modules): the FAT partition, the squashfs on it, a tmpfs over it
		local cpio="${ESYSROOT}"/usr/share/nintendo-switch-live-initramfs/live-initramfs.cpio
		[[ -f ${cpio} ]] || die "${cpio} is missing"
		cat >> arch/arm64/configs/tegra_linux_defconfig <<-EOF || die
			CONFIG_BLK_DEV_INITRD=y
			CONFIG_INITRAMFS_SOURCE="${cpio}"
			CONFIG_INITRAMFS_COMPRESSION_GZIP=y
			CONFIG_BLK_DEV_LOOP=y
			CONFIG_SQUASHFS=y
			CONFIG_SQUASHFS_XZ=y
			CONFIG_OVERLAY_FS=y
			CONFIG_FAT_FS=y
			CONFIG_VFAT_FS=y
			CONFIG_NLS_CODEPAGE_437=y
			CONFIG_NLS_ISO8859_1=y
		EOF
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
		# the newest copy another kernel version left, in the system (EROOT),
		# not on the computer it was built on
		NEWTARGET="$(ls -1v "${EROOT}${FILE}"-* 2>/dev/null | tail -n1)"
		rm "${EROOT}${FILE}"
		if [[ -n "${NEWTARGET}" ]]; then
			ln -v -s "$(basename "${NEWTARGET}")" "${EROOT}${FILE}"
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
