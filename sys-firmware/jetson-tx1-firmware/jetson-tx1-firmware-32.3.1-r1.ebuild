EAPI=7

DESCRIPTION="NVIDIA Jetson TX1 firmware only package"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"

MARIKO_FIRMWARE_SOURCE="https://github.com/libretro/Lakka-LibreELEC/raw/adfb67ff3c36d9080138dd227b07052d5a2b013d/projects/L4T/devices/Switch/custom-tegra-firmware"
MARIKO_FIRMWARE_VERSION="lakka-5.0"

SRC_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2
${MARIKO_FIRMWARE_SOURCE}/tegra210b01_xusb_firmware -> tegra210b01_xusb_firmware-${MARIKO_FIRMWARE_VERSION}.bin"

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
	insinto /lib/firmware
	newins "${DISTDIR}"/tegra210b01_xusb_firmware-"${MARIKO_FIRMWARE_VERSION}".bin tegra210b01_xusb_firmware
}
