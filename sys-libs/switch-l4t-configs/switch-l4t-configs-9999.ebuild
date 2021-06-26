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

src_install() {
	# Alsa
	if use alsa; then
		MY_CONFIG_PROTECT+=/var/lib/alsa/asound.state
		insinto /var/lib/alsa
		doins switch-alsa-ucm2/asound.state

		insinto /usr/share/alsa/ucm/tegra-snd-t210ref-mobile-rt565x
		doins switch-alsa-ucm2/HiFi
		doins switch-alsa-ucm2/tegra-snd-t210ref-mobile-rt565x.conf
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
	fi

	if [[ -n "${MY_CONFIG_PROTECT}" ]] ; then
		dodir /etc/env.d
		echo "CONFIG_PROTECT=\"${MY_CONFIG_PROTECT}\"" > "${ED}"/etc/env.d/99${PN} || die
	fi
}
