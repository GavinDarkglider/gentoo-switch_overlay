EAPI=6
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/kernel/l4t-initramfs/"
DESCRIPTION="L4T initramfs"

inherit git-r3

EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-initramfs/"
EGIT_BRANCH="master"

DEPEND="dev-embedded/u-boot-tools
		app-arch/cpio"

src_compile() {
	cd "${S}"/initramfs_files
	einfo "create initramfs.cpio.gz"

	# Empty folders not handled by source git
	mkdir dev
	mkdir mnt
	mkdir proc
	mkdir sys
	mkdir tmp
	mkdir var

	find . | cpio -H newc -o | gzip -9 > "${WORKDIR}"/new_initramfs.cpio.gz
	einfo "mkimage -A arm64 -O linux -T ramdisk -C gzip -d ${WORKDIR}/new_initramfs.cpio.gz ${WORKDIR}/initramfs"
	mkimage -A arm64 -O linux -T ramdisk -C gzip -d "${WORKDIR}"/new_initramfs.cpio.gz "${WORKDIR}"/initramfs
}

src_install() {
	insinto "/boot"
	doins "${WORKDIR}"/initramfs
}
