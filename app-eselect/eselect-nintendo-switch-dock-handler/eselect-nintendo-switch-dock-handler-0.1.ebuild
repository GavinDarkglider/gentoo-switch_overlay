EAPI=5

inherit versionator

DESCRIPTION="Eselect module for Nintendo Switch Dock Profiles"
HOMEPAGE=""
SRC_URI="https://github.com/GavinDarkglider/eselect-dockhandler/archive/master.zip"

SLOT="0"
KEYWORDS="-* arm64"
IUSE=""

RDEPEND="
	app-admin/eselect
	media-libs/nintendo-switch-alsa-configs
"

S="${WORKDIR}/eselect-dockhandler-master/"

src_unpack() {
    unpack ${A}
    cd "${S}"												
}

src_install() {
	mkdir -p "${D}/usr/share/"
	mkdir -p "${D}/usr/share/eselect/modules/"
        mkdir -p "${D}/lib/udev/rules.d"
	mkdir -p "${D}/usr/bin"
	cp -r ${S}/dock-handler ${D}/usr/share/
        cp ${S}/dock-handler.eselect ${D}/usr/share/eselect/modules/
	cp ${S}/100-dp-switch.rules ${D}/lib/udev/rules.d
	for file in ${D}/usr/share/dock-handler/*
	do
		chmod +x ${file}
	done
	ln -s ${D}/usr/share/dock-handler/DH-01-Default ${D}/usr/bin/dock-hotplug
}


