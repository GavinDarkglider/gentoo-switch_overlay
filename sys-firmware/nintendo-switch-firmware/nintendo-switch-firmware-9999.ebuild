EAPI=5

inherit versionator

DESCRIPTION="Nintendo Switch WIFI/Bluetooth Firmware"
HOMEPAGE=""

SRC_URI="https://github.com/lakka-switch/Lakka-LibreELEC/raw/master/projects/Switch/firmwares/files/brcm/BCM.hcd
	 https://github.com/lakka-switch/Lakka-LibreELEC/raw/master/projects/Switch/firmwares/files/brcm/brcmfmac4356-pcie.bin
	 https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/firmwares/files/brcm/brcmfmac4356-pcie.txt"

SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""
S="${WORKDIR}/"
src_unpack() {
    mkdir -p ${S}
    for Z in ${A}
    do
	cp ${DISTDIR}/${Z} ${S}
    done
    cd ${S}
    ln BCM.hcd BCM4356A3.hcd
}
src_install() {
    mkdir -p "${D}/lib/firmware/brcm"
    cp *  "${D}/lib/firmware/brcm" || die "Install failed!"
}
