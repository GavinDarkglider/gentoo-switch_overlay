EAPI=7

DESCRIPTION="NVIDIA Jetson TX1 firmware only package"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"

SRC_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2"

SLOT="0"
KEYWORDS="-* arm64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=app-arch/bzip2-1.0.8"

DEPEND="!!sys-libs/jetson-tx1-drivers[firmware]"

S="${WORKDIR}/extracted"

src_unpack() {
	default
	mkdir "${S}"
	cd "${S}"
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2
}

src_install() {
	insinto /lib
	doins -r lib/firmware || die "Install failed!"
}
