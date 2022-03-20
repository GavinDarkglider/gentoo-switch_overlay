EAPI=6

DESCRIPTION="Alsa UCM for Nintendo Switch"
HOMEPAGE="https://gitlab.com/switchroot/switch-l4t-configs/-/tree/master/switch-alsa-ucm2"

SRC_URI="https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm2/HiFi.conf?inline=false -> switch-alsa-ucm-HiFi-${PV}.conf
         https://gitlab.com/switchroot/switch-l4t-configs/-/raw/master/switch-alsa-ucm2/tegra-snd-t210r.conf?inline=false -> switch-alsa-ucm-tegra-snd-t210r.conf-${PV}"

SLOT="0"
KEYWORDS="-* ~arm64"
IUSE=""

RDEPEND="
    media-libs/alsa-lib
    media-sound/alsa-utils
"

S="${WORKDIR}"

src_install() {
    insinto /usr/share/alsa/ucm2/tegra-snd-t210r
    newins "${DISTDIR}"/switch-alsa-ucm-HiFi-${PV}.conf HiFi.conf
    newins "${DISTDIR}"/switch-alsa-ucm-tegra-snd-t210r.conf-${PV} tegra-snd-t210r.conf
}

