EAPI=5

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 firmware package"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.download.nvidia.com/embedded/L4T/r32_Release_v1.0/jetson-nano/BSP/Jetson-Nano-Tegra210_Linux_R32.1.0_aarch64.tbz2"

SLOT="0"
KEYWORDS="arm arm64"
IUSE=""

S="${WORKDIR}/Linux_for_Tegra/nv_tegra"

src_unpack() {
    unpack ${A}
    cd "${S}"
    unpack ./nvidia_drivers.tbz2
}

src_install() {
    dodir /lib/firmware
    cp -R lib/firmware "${D}/lib/" || die "Install failed!"
}
