EAPI=5

inherit versionator

DESCRIPTION="Nintendo Switch Xorg Configuration"
HOMEPAGE=""
SRC_URI="https://github.com/GavinDarkglider/nintendo-switch-x11-configuration/archive/master.zip -> nintendo_switch_xorg_configs.zip"

SLOT="0"
KEYWORDS="-* arm64"
IUSE="lxdm"

RDEPEND="
	x11-base/xorg-server
"

S="${WORKDIR}/nintendo-switch-x11-configuration-master/"

src_unpack() {
    unpack ${A}
    cd "${S}"												
}

src_install() {
	mkdir -p "${D}/etc/X11/"
	cp -r ${S}/xorg.conf.d ${D}/etc/X11/
        cp ${S}/xorg.conf ${D}/etc/X11/
	use lxdm && mkdir ${D}/etc/lxdm
        use lxdm && cp ${S}/PostLogin ${D}/etc/lxdm/
        use lxdm && cp ${S}/PostLogout ${D}/etc/lxdm/
}


