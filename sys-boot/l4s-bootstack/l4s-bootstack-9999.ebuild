EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://github.com/Linux-4-Switch/bootstack"
DESCRIPTION="Linux-4-Switch bootstack files"

inherit git-r3 sdcard-mount

IUSE="+initramfs"

EGIT_REPO_URI="https://github.com/Linux-4-Switch/bootstack"
EGIT_BRANCH="master"
EGIT_SUBMODULES=()

DEPEND="sys-boot/cbfstool
		dev-embedded/u-boot-tools
		sys-boot/nintendo-switch-u-boot
		sys-apps/dtc
		initramfs? ( app-arch/cpio )"

src_unpack() {
	git-r3_src_unpack
	use initramfs && unpack "${S}"/src/initramfs_files.tar.gz
}

src_prepare() {
	sed -i 's/ubuntu/gentoo/g' "${S}"/src/uboot-scripts/linux_boot.txt
	sed -i 's/SWR-UBU/SWR-GEN/g' "${S}"/src/uboot-scripts/linux_boot.txt
	sed -i 's/SWR-UBU/SWR-GEN/g' "${S}"/src/uboot-scripts/uenv.txt
	sed -i 's/runlevel=2/runlevel=3/g' "${S}"/src/uboot-scripts/uenv.txt
	eapply_user
}

src_compile() {
	einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
	einfo "   ${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
	sh "${FILESDIR}"/update-coreboot.sh "${S}"/src/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf || die "patching coreboot failed"

	einfo "mkimage -A arm -T script -O linux -d ${S}/src/uboot-scripts/linux_boot.txt ${S}/boot.scr"
	mkimage -A arm -T script -O linux -d "${S}"/src/uboot-scripts/linux_boot.txt "${S}"/boot.scr

	cd "${S}"/src/uboot-scripts/overlays

	mkdir overlays
	einfo "dtc -I dts -O dtb -o overlays/tegra210-icosa_emmc-overlay.dtbo emmc_overlay.dts"
	dtc -I dts -O dtb -o overlays/tegra210-icosa_emmc-overlay.dtbo emmc_overlay.dts
	einfo "dtc -I dts -O dtb -o overlays/tegra210-icosa-UART-B-overlay.dtbo uart_b_debug.dts"
	dtc -I dts -O dtb -o overlays/tegra210-icosa-UART-B-overlay.dtbo uart_b_debug.dts
	cp nfs.txt overlays/

	if use initramfs; then
		cd "${WORKDIR}"/initramfs_files
		einfo "create initramfs.cpio.gz"
		find . | cpio -H newc -o | gzip -9 > "${WORKDIR}"/new_initramfs.cpio.gz
		einfo "mkimage -A arm64 -O linux -T ramdisk -C gzip -d ${WORKDIR}/new_initramfs.cpio.gz ${WORKDIR}/initramfs"
		mkimage -A arm64 -O linux -T ramdisk -C gzip -d "${WORKDIR}"/new_initramfs.cpio.gz "${WORKDIR}"/initramfs
	fi
}

src_install() {
	dobin "${FILESDIR}"/update-coreboot.sh

	dodir "${SDCARD_DESTDIR}"/switchroot/gentoo
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo

	doins boot.scr
	doins src/coreboot.rom
	doins src/uboot-scripts/uenv.txt
	doins src/uboot-scripts/uenv_readme.txt
	doins -r src/uboot-scripts/overlays/overlays

	if use initramfs; then
		doins "${WORKDIR}"/initramfs
	fi

	insinto "${SDCARD_DESTDIR}"/bootloader/ini
	doins "${S}"/src/hekate_ini/L4T-gentoo.ini
}

pkg_config() {
	if [ -f /usr/share/u-boot/u-boot.elf ]; then
		einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
		einfo "${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
		"${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf  || die "patching coreboot failed"
	else
		ewarn "No u-boot.elf file found, skip updating coreboot"
	fi

	sdcard-mount_pkg_setup

	if [[ -n "${SDCARD_MOUNT_POINT}" ]] ; then
		cp -va "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${SDCARD_MOUNT_POINT}"/switchroot/gentoo || die "Pls. check if right medium mounted"
	fi
}

pkg_postinst() {
	einfo "Update the u-boot in coreboot.rom using "
	einfo "   ebuild /var/db/repos/switch_overlay/sys-boot/nintendo-switch-coreboot-bin/nintendo-switch-coreboot-bin-9999.ebuild config"
}
