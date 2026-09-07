# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit git-r3

KEYWORDS="arm64"
SLOT="0"

IUSE=""

HOMEPAGE="https://github.com/theofficialgman/vk_layer_tegra_dc_present"

DESCRIPTION="Vulkan implicit layer for NVIDIA Tegra L4T r32.x that fixes tearing in Vulkan-on-X11 presentation."

EGIT_REPO_URI="https://github.com/theofficialgman/vk_layer_tegra_dc_present"
EGIT_BRANCH="master"

COMMON_DEPEND="
        x11-libs/libX11
        x11-libs/libxcb
        x11-libs/libXrandr
"

RDEPEND="
        ${COMMON_DEPEND}
        media-libs/vulkan-loader

"
DEPEND="
        ${COMMON_DEPEND}
        dev-util/vulkan-headers"
