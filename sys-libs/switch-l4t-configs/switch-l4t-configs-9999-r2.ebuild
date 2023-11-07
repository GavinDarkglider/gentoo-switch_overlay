# Copyright 2022 Alexander Weber, Gavin Darkglider
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit git-r3 udev

DESCRIPTION="Linux configs for the Nintendo Switch"
HOMEPAGE="https://gitlab.com/switchroot/switch-l4t-configs"

# This fork is temporary because of https://gitlab.com/switchroot/switch-l4t-configs/-/merge_requests/9
EGIT_REPO_URI="https://gitlab.com/bell07/switch-l4t-configs"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 arm"

IUSE="alsa +brcm +dock-handler X"

DEPEND="
X? ( !x11-base/nintendo-switch-x11-configuration )
dock-handler? (
  !app-eselect/eselect-nintendo-switch-dock-handler
  !x11-misc/dock-hotplug )"

RDEPEND="dock-handler? (
  app-admin/sudo
  dev-libs/glib
  media-libs/libpulse
  media-tv/v4l-utils
  x11-apps/xrandr
)"

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

	if use dock-handler; then
		dobin switch-dock-handler/dock-hotplug

		insinto /etc/xdg/autostart/
		doins switch-dock-handler/nintendo-switch-display.desktop

		insinto /lib/udev/rules.d
		doins switch-dock-handler/92-dp-switch.rules
	fi

	# X server configurations
	if use X; then
		insinto /etc/X11/xorg.conf.d
		doins switch-xorg-conf/*.conf

		insinto /lib/udev/rules.d
		doins switch-touch-rules/99-switch-touchscreen.rules
	fi
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
}
