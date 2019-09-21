EAPI=5

inherit versionator

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE=""
SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/archive/master/switch-l4t-configs-master.tar.gz
	 https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrasndt210ref
         https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrahda"

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
    cp "${DISTDIR}"/asound.conf.tegrahda ./
    cp "${DISTDIR}"/asound.conf.tegrasndt210ref ./
}

src_install() {
<<<<<<< HEAD
	mkdir -p "${D}"/usr/share/alsa/ucm/t210ref-mobile-rt565x"
	mkdir -p "${D}"/usr/share/alsa/cards
	mkdir -p "${D}"/etc"
	mkdir -p "${D}"/var/lib/alsa/"
	cp ${S}/* ${D}/usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
=======
	mkdir -p "${D}"/usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
	mkdir -p "${D}"/etc
	mkdir -p "${D}"/var/lib/alsa
	cp "${S}"/* "${D}"/usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
>>>>>>> d96b52417e98823b6ce702cf2e6948c60e5d04ae
        cp "${FILESDIR}"/asound.state "${D}"/var/lib/alsa
        cp "${FILESDIR}"/tegra-hda.conf "${D}"/usr/share/alsa/cards
	cp "${FILESDIR}"/tegra-snd-t210ref.conf "${D}"/usr/share/alsa/cards
	cp "${FILESDIR}"/tegra-alc5632.conf "${D}"/usr/share/alsa/cards
	mv "${D}"/usr/share/alsa/ucm/t210ref-mobile-rt565x/asound.conf.* "${D}"/etc/
	ln -s "${D}"/etc/asound.conf.tegra210ref "${D}"/etc/asound.conf
}
