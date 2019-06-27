EAPI=5

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.download.nvidia.com/embedded/L4T/r32_Release_v1.0/jetson-nano/BSP/Jetson-Nano-Tegra210_Linux_R32.1.0_aarch64.tbz2"

SLOT="0"
KEYWORDS="-* arm64"
IUSE="+egl vulkan"

RDEPEND="
	~sys-firmware/jetson-tx1-firmware-${PV}
	=x11-base/xorg-server-1.19.6:=
	egl? ( media-libs/libglvnd )
        vulkan? ( media-libs/vulkan-loader )
"

S="${WORKDIR}/Linux_for_Tegra/nv_tegra"

QA_TEXTRELS_arm64="usr/lib64/tegra/libnvidia-eglcore.so.${PV}
	usr/lib64/tegra/libnvidia-glcore.so.${PV}
	usr/lib64/tegra/libcuda.so.1.1
	usr/lib64/tegra/libGL.so.1"


src_unpack() {
    unpack ${A}
    cd "${S}"
    unpack ./nvidia_drivers.tbz2												
}

src_install() {
    dodir /etc
    dodir /var
    dodir /usr/bin
    dodir /usr/sbin
    cp -R etc "${D}/" || die "Install failed!"
    cp -R var "${D}/" || die "Install failed!"
    cp -R usr/bin "${D}/usr/" || die "Install failed!"
    cp -R usr/sbin "${D}/usr/" || die "Install failed!"

    sed -i -e 's:^/usr/lib/:/usr/'"lib64"'/:' "${D}"/etc/ld.so.conf.d/nvidia-tegra.conf

    exeinto /usr/lib64/xorg/modules/drivers
    doexe usr/lib/xorg/modules/drivers/nvidia_drv.so

    dodir /usr/lib64/opengl/nvidia/extensions
    exeinto /usr/lib64/opengl/nvidia/extensions
    doexe usr/lib/xorg/modules/extensions/libglxserver_nvidia.so

    use egl && mv usr/lib/aarch64-linux-gnu/tegra-egl/*.so.? usr/lib/aarch64-linux-gnu/tegra/
    use egl && mv usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json usr/lib/aarch64-linux-gnu/tegra/
    rm -rf usr/lib/aarch64-linux-gnu/tegra-egl
    cp -R usr/lib/aarch64-linux-gnu/* "${D}/usr/lib64/" || die "Install failed!"

    dosym /usr/lib64/tegra /usr/lib64/opengl/nvidia/lib
    #dosym /usr/lib64/tegra/libGLX_nvidia.so.0 /usr/lib64/tegra/libGL.so
    #dosym /usr/lib64/tegra/libGLX_nvidia.so.0 /usr/lib64/tegra/libGL.so.0
    #dosym /usr/lib64/tegra/libGLX_nvidia.so.0 /usr/lib64/tegra/libGL.so.1
    use egl && dosym /usr/lib64/tegra/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
    use vulkan && dosym /usr/lib64/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
    #use cuda && dosym libcuda.so.1.1 /usr/lib64/tegra/libcuda.so.1
}

pkg_postinst() {
        [ "${ROOT}" != "/" ] && return 0

        ldconfig
}
