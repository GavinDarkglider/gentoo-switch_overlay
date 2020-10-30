EAPI=6

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE="https://github.com/lakka-switch/Lakka-LibreELEC/tree/master/projects/Switch/devices/L4T/filesystem/etc
          https://gitlab.com/switchroot/switch-l4t-configs"

SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm/HiFi?inline=false -> switch-alsa-ucm-HiFi
         https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm/tegra-snd-t210ref-mobile-rt565x.conf?inline=false -> switch-alsa-ucm-tegra-snd-t210ref-mobile-rt565x.conf
         https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrahda
         https://raw.githubusercontent.com/lakka-switch/Lakka-LibreELEC/master/projects/Switch/devices/L4T/filesystem/etc/asound.conf.tegrasndt210ref"

SLOT="0"
KEYWORDS="-* ~arm64"
IUSE=""

RDEPEND="
    media-libs/alsa-lib
    media-sound/alsa-utils
"

S="${WORKDIR}"

src_install() {
    insinto /etc
    doins "${DISTDIR}"/asound.conf.tegrahda
    doins "${DISTDIR}"/asound.conf.tegrasndt210ref

    insinto /usr/share/alsa/cards
    doins "${FILESDIR}"/tegra-hda.conf
    doins "${FILESDIR}"/tegra-snd-t210r.conf
    doins "${FILESDIR}"/tegra-alc5632.conf

    insinto /usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
    newins "${DISTDIR}"/switch-alsa-ucm-HiFi HiFi
    newins "${DISTDIR}"/switch-alsa-ucm-tegra-snd-t210ref-mobile-rt565x.conf tegra-snd-t210ref-mobile-rt565x.conf

    newinitd "${FILESDIR}"/init.d-alsa-ucm-fix alsa-ucm-fix
}


pkg_postinst() {
    if ! [[ -f /etc/asound.conf ]]; then
        einfo "No /etc/asound.conf found, create symlink to /etc/asound.conf.tegrasndt210ref"
        ln -s /etc/asound.conf.tegrasndt210ref /etc/asound.conf
    fi
}
