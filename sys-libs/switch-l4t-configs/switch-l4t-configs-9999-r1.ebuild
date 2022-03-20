# Copyright 2021 Alexander Weber
# Distributed under the terms of the GNU General Public License v3

EAPI=7

inherit git-r3

DESCRIPTION="Linux configs for the Nintendo Switch"
HOMEPAGE="https://gitlab.com/switchroot/switch-l4t-configs"
EGIT_REPO_URI="https://gitlab.com/switchroot/switch-l4t-configs"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="alsa +brcm X"

DEPEND="alsa? ( !media-libs/nintendo-switch-alsa-configs )
	X? ( !x11-base/nintendo-switch-x11-configuration )"

RDEPEND="alsa? ( media-sound/alsa-utils )" # to load asound.state

src_install() {
	# Alsa
	if use alsa; then
		insinto /usr/share/alsa/ucm2/tegra-snd-t210r
		doins switch-alsa-ucm2/HiFi.conf
		doins switch-alsa-ucm2/tegra-snd-t210r.conf
	fi

	# Missed broadcom firmware file
	if use brcm; then
		insinto lib/firmware/brcm
		doins switch-wireless-nvram/brcmfmac4356-pcie.txt
	fi

	# X server configurations
	if use X; then
		insinto /etc/X11/xorg.conf.d
		doins switch-xorg-conf/*.conf

		insinto /lib/udev/rules.d
		doins switch-touch-rules/99-switch-touchscreen.rules
	fi

	# Write config protect environment setting
	if [[ -n "${MY_CONFIG_PROTECT}" ]] ; then
		dodir /etc/env.d
		echo "CONFIG_PROTECT=\"${MY_CONFIG_PROTECT}\"" > "${ED}"/etc/env.d/99${PN} || die
	fi
}
