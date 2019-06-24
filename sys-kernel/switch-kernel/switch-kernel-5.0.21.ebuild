# Copyright 1999-2019 Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="~arm64"
SLOT="${PV}"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo"

K_DEFCONFIG="nintendo_switch_defconfig"

DESCRIPTION="Build Nintendo Switch kernel from sources package"

DEPEND="=sys-kernel/switch-sources-${PV}*
	sys-kernel/linux-firmware"

src_unpack() {
	einfo "copying /usr/src/linux-${PV%}-switch into ${S}"
	cp -a "${ROOT}/usr/src/linux-${PV%}-switch" "${S}" || die "copy failed"
}

src_configure() {
    einfo "Use provided nintendo_switch_defconfig"
    cp "${S}"/arch/arm64/configs/nintendo_switch_defconfig  "${S}"/.config || die "copy failed"

    einfo "Remove not supported broadcom firmware from CONFIG_EXTRA_FIRMWARE"
    sed -i 's/brcm.*/"/g' .config || die "sed failed"

    einfo "Apply olddefconfig"
    cd "${S}"
    emake olddefconfig 2>/dev/null || die "emake olddefconfig failed"
}

src_compile() {
	emake || die "emake failed"
	emake modules || die "emake modules failed"
}

src_install() {
	mkdir "${D}/boot"
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake modules_install || die "emake modules_install failed"
	INSTALL_PATH="${D}/boot" INSTALL_MOD_PATH="${D}" emake install || die "make install failed"
}
