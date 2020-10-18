EAPI=6

inherit versionator

DESCRIPTION="Nintendo Switch WIFI/Bluetooth Firmware"
HOMEPAGE=""

SRC_URI="https://github.com/bell07/bashscripts-switch_gentoo/raw/master/distfiles/BCM4356A3.hcd
         https://github.com/bell07/bashscripts-switch_gentoo/raw/master/distfiles/brcmfmac4356-pcie.txt
         https://github.com/bell07/bashscripts-switch_gentoo/raw/master/distfiles/brcmfmac4356-pcie.bin"

SLOT="0"
KEYWORDS="arm64"
IUSE=""

S="${WORKDIR}"
src_unpack() {
	einfo "Nothing to unpack"
}

src_install() {
    insinto lib/firmware/brcm
    doins "${DISTDIR}"/BCM4356A3.hcd
    doins "${DISTDIR}"/brcmfmac4356-pcie.txt
    doins "${DISTDIR}"/brcmfmac4356-pcie.bin
}
