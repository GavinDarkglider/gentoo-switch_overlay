EAPI=6

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2"
SLOT="0"
KEYWORDS="-* ~arm64"
IUSE="+egl gstreamer vulkan wayland"
RESTRICT="preserve-libs"

DEPEND=">=app-arch/bzip2-1.0.8"

RDEPEND="
	~sys-firmware/jetson-tx1-firmware-${PV}
	=x11-base/xorg-server-1.19.6:=
	egl? ( media-libs/libglvnd )
	gstreamer? ( gst-plugins-base/gst-plugins-base )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
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

    use wayland || rm "${S}"/usr/lib/aarch64-linux-gnu/tegra/libnvidia-egl-wayland.so
    use gstreamer || rm "${S}"/usr/lib/aarch64-linux-gnu/tegra/libnvdsbufferpool.so.1.0.0
}

my_do_lib_recursive() {
	# $1 is the source path
	# $2 is the target path
	for f in "$1"/*
	do
		if [ -h "${f}" ]
		then
			dosym "$(readlink "${f}"| sed 's:usr/lib/aarch64-linux-gnu:usr/lib64:g')" "$2"/"$(basename "${f}")"
		elif [ -f "${f}" ]
		then
			if [ -n "$(echo "$f" | grep -e [.]so[.] -e [.]so$)" ]
			then
				insinto "$2"
				doins "${f}"
			elif [ -x "${f}" ]
			then
				exeinto "$2"
				doexe "${f}"
			else
				insinto "$2"
				doins "${f}"
			fi
		elif [ -d "${f}" ]
		then
			my_do_lib_recursive "${f}" "${2}/$(basename "$f")"
		else
			ewarn "skipped broken file in my_do_lib_recursive ${f}"
		fi
	done
}

src_install() {
    insinto "/etc" && doins "${S}/etc/nv_tegra_release"

    insinto "/etc/ld.so.conf.d" && doins "${S}/etc/ld.so.conf.d/nvidia-tegra.conf"

    dobin "/usr/bin/nvidia-bug-report-tegra.sh"

    for f in "usr/sbin/"*
    do
        dosbin "${f}"
    done

    insinto "/lib/udev/rules.d"
    for f in "${FILESDIR}"/*.rules
    do
        doins "${f}"
    done

    my_do_lib_recursive  "usr/lib/aarch64-linux-gnu/" "/usr/lib64/"
    my_do_lib_recursive  "usr/lib/xorg/" "/usr/lib64/xorg/"

    dosym /usr/lib64/tegra /usr/lib64/opengl/nvidia/lib
    use egl && dosym /usr/lib64/tegra/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
    use vulkan && dosym /usr/lib64/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

	insinto "/" && doins -r var
}

pkg_postinst() {
        [ "${ROOT}" != "/" ] && return 0

        ldconfig
}
