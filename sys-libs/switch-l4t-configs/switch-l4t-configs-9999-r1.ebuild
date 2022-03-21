# Copyright 2022 Alexander Weber, Gavin Darkglider
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

DEPEND="X? ( !x11-base/nintendo-switch-x11-configuration )"

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
		newins switch-wireless-nvram/brcmfmac4356-pcie.txt brcmfmac4356A3-pcie.txt
	fi

	# X server configurations
	if use X; then
		insinto /etc/X11/xorg.conf.d
		doins switch-xorg-conf/*.conf

		insinto /lib/udev/rules.d
		doins switch-touch-rules/99-switch-touchscreen.rules
	fi
}
