EAPI=6

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"

SRC_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2"

SLOT="0"
KEYWORDS="-* arm64"
IUSE="alsa cuda doc +egl +firmware gstreamer usb-device v4l vulkan wayland X"
RESTRICT="preserve-libs mirror"

DEPEND="app-arch/bzip2
	firmware? ( !!sys-firmware/jetson-tx1-firmware )"

RDEPEND="
	X? ( x11-base/xorg-server )
	egl? ( media-libs/libglvnd )
	gstreamer? ( media-libs/gst-plugins-base )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )"

S="${WORKDIR}/extracted"

src_unpack() {
	default
	mkdir "${S}"
	cd "${S}"

	# extract BSP files
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/config.tbz2
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nv_tools.tbz2
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nv_sample_apps/nvgstapps.tbz2
}

src_prepare() {
	# Patch files
	sed -i 's:libGLX_nvidia.so.0:/usr/lib64/tegra/libGLX_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra/nvidia_icd.json
	sed -i 's:libEGL_nvidia.so.0:/usr/lib64/tegra/libEGL_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json
	sed -i 's:libnvidia-egl-wayland.so.1:/usr/lib64/tegra/libnvidia-egl-wayland.so.1:g' usr/share/egl/egl_external_platform.d/nvidia_wayland.json 
	echo "/usr/lib64/tegra" > etc/ld.so.conf.d/nvidia-tegra.conf

	# All files in /usr/lib/aarch64-linux-gnu are installed bellow. excepting the deleted at this place
	cd "${S}"/usr/lib/aarch64-linux-gnu/tegra

	use cuda      || rm libcuda*so* libnvbufsurftransform.so* libnvofsdk.so* libnvscf.so* libnvargus.so* libnvcameratools.so* libnveglstreamproducer.so*
	use gstreamer || rm libnvdsbufferpool.so*
	use wayland   || rm libnvidia-egl-wayland.so* libnvvulkan-producer.so*
	use v4l       || rm lib*v4l*so* libnvodm_imager.so*
	use vulkan    || rm lib*vulkan*so*


	rm "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf
	eapply_user
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
	# General part
	insinto /etc/ld.so.conf.d && doins etc/ld.so.conf.d/nvidia-tegra.conf
	dobin usr/bin/nvidia-bug-report-tegra.sh
	insinto /lib/udev/rules.d && doins etc/udev/rules.d/99-tegra-devices.rules
	
	# ~ 100 files unsorted. Some files are deleted conditionally in src_prepare step
	my_do_lib_recursive usr/lib/aarch64-linux-gnu/tegra /usr/lib64/tegra

	# Misc alsa files
	if use alsa; then
		insinto /etc
		doins etc/asound.conf.tegrasndt210ref
		doins etc/asound.conf.tegrahda
		
		insinto /lib/udev/rules.d
		doins etc/udev/rules.d/90-alsa-asound-tegra.rules
		doins etc/udev/rules.d/92-hdmi-audio-tegra.rules
		
		insinto /usr/share
		doins -r usr/share/alsa
	fi

	# Cuda
	if use cuda; then
		insinto /usr/lib64 && doins usr/lib/aarch64-linux-gnu/libnvsample_cudaprocess.so
	fi

	# lot of documentation
	if use doc; then
		dodoc -r /usr/share/doc
	fi
		
	# EGL
	if use egl; then
		my_do_lib_recursive usr/lib/aarch64-linux-gnu/tegra-egl /usr/lib64/tegra
		dosym /usr/lib64/tegra/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
	fi

	# Firmware files
	if use firmware; then
		insinto /lib
		doins -r lib/firmware || die "Install failed!"
	fi

	# Gstreamer
	if use gstreamer; then
		my_do_lib_recursive  usr/lib/aarch64-linux-gnu/gstreamer-1.0 /usr/lib64/gstreamer-1.0
		insinto /usr/lib64 && doins usr/lib/aarch64-linux-gnu/libgst*
	fi
	
	# Usb device gadget
	if use usb-device; then
		insinto /lib/udev/
		doins etc/udev/rules.d/99-nv-l4t-usb-device-mode.rules
		exeinto /opt/nvidia/l4t-usb-device-mode
		doexe opt/nvidia/l4t-usb-device-mode/*.sh
		insinto /opt/nvidia/l4t-usb-device-mode
		doins opt/nvidia/l4t-usb-device-mode/LICENSE.filesystem.img
	fi
	
	# Vulkan
	if use vulkan; then
		dosym /usr/lib64/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
	fi

	# Wayland
	if use wayland; then
		insinto usr/share/egl/egl_external_platform.d && doins usr/share/egl/egl_external_platform.d/nvidia_wayland.json
	fi
	
	# Camera
	if use v4l; then
		insinto /usr/lib64 && doins usr/lib/aarch64-linux-gnu/libv4l*so*
		dosym /usr/lib64/tegra/libv4l2_nvvideocodec.so usr/lib/aarch64-linux-gnu/libv4l/plugins/nv/libv4l2_nvvideocodec.so
		dosym /usr/lib64/tegra/libv4l2_nvvidconv.so usr/lib/aarch64-linux-gnu/libv4l/plugins/nv/libv4l2_nvvidconv.so
		insinto /var/nvidia && doins -r /var/nvidia/nvcam
	fi
	
	# X Server
	if use X; then
		my_do_lib_recursive usr/lib/xorg /usr/lib64/xorg
		dosym /usr/lib64/tegra /usr/lib64/opengl/nvidia/lib
		insinto /etc/X11/xorg.conf.d && newins etc/X11/xorg.conf 30-jetson-tx1-drivers.conf
	fi
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	ldconfig
	if use alsa && ! [[ -f /etc/asound.conf ]]; then
        einfo "No /etc/asound.conf found, create symlink to /etc/asound.conf.tegrasndt210ref"
        ln -s /etc/asound.conf.tegrasndt210ref /etc/asound.conf
    fi
}
