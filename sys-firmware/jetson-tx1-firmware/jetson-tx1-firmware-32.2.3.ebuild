EAPI=5

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 firmware package"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.nvidia.com/embedded/r32-2-3_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.2.3_aarch64.tbz2"

SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

RDEPEND=">=app-arch/bzip2-1.0.8"

S="${WORKDIR}/Linux_for_Tegra/nv_tegra"

src_unpack() {
    unpack ${A}
    cd "${S}"
    unpack ./nvidia_drivers.tbz2
}

src_install() {
    dodir /lib/firmware
    cp -R lib/firmware "${D}/lib/" || die "Install failed!"
    dosym "/lib/firmware/tegra21x" "/lib/firmware/gm20b" || die "Install failed!"
}
