# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/fceu-next"
LIBRETRO_COMMIT_SHA="ebd46a592c23a8091abd72e74cf0d9f4517769e1"
inherit libretro-core

DESCRIPTION="Libretro implementation of FCEUmm/FCEUX. (Nintendo Entertainment System)"
HOMEPAGE="https://github.com/libretro/fceu-next"
KEYWORDS="~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND="!games-emulation/libretro-fceumm"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

S="${S}/fceumm-code"
LIBRETRO_CORE_NAME=fceumm

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to have the following files in your 'system_directory' folder:"
		ewarn "disksys.rom (Famicom Disk System BIOS)"
		ewarn ""
		ewarn ""
	fi
}
