EAPI=6

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE="https://gitlab.com/switchroot/switch-l4t-configs/-/tree/master/switch-alsa-ucm2"

SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm2/HiFi?inline=false -> switch-alsa-ucm-HiFi-${PV}
         https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm2/tegra-snd-t210ref-mobile-rt565x.conf?inline=false -> switch-alsa-ucm-tegra-snd-t210ref-mobile-rt565x.conf-${PV}"

SLOT="0"
KEYWORDS="-* ~arm64"
IUSE=""

RDEPEND="
    media-libs/alsa-lib
    media-sound/alsa-utils
"

S="${WORKDIR}"

src_install() {
    insinto /usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
    newins "${DISTDIR}"/switch-alsa-ucm-HiFi-${PV} HiFi
    newins "${DISTDIR}"/switch-alsa-ucm-tegra-snd-t210ref-mobile-rt565x.conf-${PV} tegra-snd-t210ref-mobile-rt565x.conf

    newinitd "${FILESDIR}"/init.d-alsa-ucm-fix alsa-ucm-fix
}

