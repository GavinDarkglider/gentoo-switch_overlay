EAPI=5

inherit versionator

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE=""
SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/archive/master/switch-l4t-configs-master.tar.gz"

SLOT="0"
KEYWORDS="-* arm64"
IUSE=""

RDEPEND="
	media-libs/alsa-lib
"

S="${WORKDIR}/switch-l4t-configs-master/switch-alsa-ucm/"

src_unpack() {
    unpack ${A}
    cd "${S}"												
}

src_install() {
	mkdir -p "${D}/usr/share/alsa/ucm/t210ref-mobile-rt565x"
	cp ${S}/* ${D}/usr/share/alsa/ucm/t210ref-mobile-rt565x
}


