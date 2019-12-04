EAPI=6

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.nvidia.com/embedded/r32-2-3_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.2.3_aarch64.tbz2"
SLOT="0"
KEYWORDS="-* ~arm64"
IUSE="+egl vulkan"

DEPEND=">=app-arch/bzip2-1.0.8"

RDEPEND="
	~sys-firmware/jetson-tx1-firmware-${PV}
	=x11-base/xorg-server-1.19.6:=
	egl? ( media-libs/libglvnd )
        vulkan? ( media-libs/vulkan-loader )
"

QA_TEXTRELS_arm64="usr/lib64/tegra/libnvidia-eglcore.so.${PV}
	usr/lib64/tegra/libnvidia-glcore.so.${PV}
	usr/lib64/tegra/libcuda.so.1.1
	usr/lib64/tegra/libGL.so.1"


src_unpack() {
    unpack ${A}
    mkdir "${S}" || die "unpack failed"
    cd "${S}"
    unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2

    sed -i -e 's:^/usr/lib/:/usr/'"lib64"'/:' "${S}"/etc/ld.so.conf.d/nvidia-tegra.conf

    if use egl 
    then 
		einfo "Setup egl"
        mv "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/*.so.? "${S}"/usr/lib/aarch64-linux-gnu/tegra/
        mv "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json "${S}"/usr/lib/aarch64-linux-gnu/tegra/
    fi
    rm -rf "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl
}

my_do_lib_recursive() {
	# $1 is the source path
	# $2 is the target path
	for f in "$1"/*
	do
		if [ -f "${f}" ]
		then
			if [ -x "$f" ]
			then
				exeinto "$2"
				doexe "$f"
			else
				insinto "$2"
				doins "$f"
			fi
		elif [ -d "${f}" ]
		then
			my_do_lib_recursive "${f}" "${2}/$(basename "$f")"
		else
			die "not supported file in my_do_lib_recursive"
		fi
	done
}


src_install() {
    doins -r etc
    doins -r var

    dobin "usr/bin/nvidia-bug-report-tegra.sh"
    for f in "usr/sbin/"*
    do
        dosbin "${f}"
    done

    insinto /lib/udev/rules.d
    for f in "${FILESDIR}"/*.rules
    do
        doins "${f}"
    done

	my_do_lib_recursive  "usr/lib/aarch64-linux-gnu/" "/usr/lib64/"

    exeinto /usr/lib64/xorg/modules/drivers
    doexe usr/lib/xorg/modules/drivers/nvidia_drv.so

    exeinto /usr/lib64/opengl/nvidia/extensions
    doexe usr/lib/xorg/modules/extensions/libglxserver_nvidia.so

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
