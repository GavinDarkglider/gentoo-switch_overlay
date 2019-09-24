EAPI=5

inherit versionator

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE="https://github.com/lakka-switch/Lakka-LibreELEC/tree/master/projects/Switch/devices/L4T/filesystem/etc"
SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/archive/master/switch-l4t-configs-master.tar.gz
         https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrahda
         https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrasndt210ref"

SLOT="0"
KEYWORDS="-* arm64"
IUSE=""

RDEPEND="
	media-libs/alsa-lib
"

S="${WORKDIR}/switch-l4t-configs-master/switch-alsa-ucm/"

src_install() {
    insinto /etc
    doins "${DISTDIR}"/asound.conf.tegrahda
    doins "${DISTDIR}"/asound.conf.tegrasndt210ref

    insinto /var/lib/alsa
    doins ${FILESDIR}"/asound.state"

    insinto /usr/share/alsa/cards
    doins "${FILESDIR}"/tegra-hda.conf
    doins "${FILESDIR}"/tegra-snd-t210r.conf
    doins "${FILESDIR}"/tegra-alc5632.conf

    insinto /usr/share/alsa/ucm/t210ref-mobile-rt565x
    for file in "${S}"/*; do
        doins "$file" 
    done
}


pkg_postinst() {
	if ! [[ -f /etc/asound.conf ]]; then
		einfo "No /etc/asound.conf found, create symlink to /etc/asound.conf.tegra210ref"
		ln -s /etc/asound.conf.tegra210ref /etc/asound.conf
	fi
}
