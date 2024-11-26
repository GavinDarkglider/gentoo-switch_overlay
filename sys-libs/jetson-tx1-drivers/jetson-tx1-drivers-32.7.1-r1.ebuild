EAPI=7

inherit udev

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"

MARIKO_FIRMWARE_SOURCE="https://github.com/libretro/Lakka-LibreELEC/raw/adfb67ff3c36d9080138dd227b07052d5a2b013d/projects/L4T/devices/Switch/custom-tegra-firmware"
MARIKO_FIRMWARE_VERSION="lakka-5.0"

SRC_URI="https://developer.nvidia.com/embedded/l4t/r32_release_v7.1/t210/jetson-210_linux_r32.7.1_aarch64.tbz2
${MARIKO_FIRMWARE_SOURCE}/tegra210b01_xusb_firmware -> tegra210b01_xusb_firmware-${MARIKO_FIRMWARE_VERSION}.bin"

SLOT="0"
KEYWORDS="-* ~arm64"
IUSE="alsa doc +egl firmware gstreamer usb-device vulkan X v4l pulseaudio"
RESTRICT="preserve-libs mirror"

DEPEND="app-arch/bzip2
	firmware? ( !!sys-firmware/jetson-tx1-firmware )"

RDEPEND="
	X? ( <x11-base/xorg-server-21 )
	egl? ( >media-libs/mesa-21.1 x11-libs/libdrm[video_cards_tegra] )
	gstreamer? ( media-libs/gst-plugins-bad
            media-libs/gst-plugins-ugly )
	vulkan? ( media-libs/vulkan-loader )
	v4l? ( =media-libs/libv4l-1.18.0[video_cards_tegra] )"

# Todo.... Build gstreamer/v4l stuff from upstream packages, with tegra patches.

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
	sed -i 's:libEGL_nvidia.so.0:/usr/lib64/tegra-egl/libEGL_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json

	echo "/usr/lib64/tegra" > etc/ld.so.conf.d/nvidia-tegra.conf

	# All files in /usr/lib/aarch64-linux-gnu are installed bellow. excepting the deleted at this place
	cd "${S}"/usr/lib/aarch64-linux-gnu/

	use egl       || rm -rv tegra-egl \
					 tegra/libnvvulkan-producer.so* \
	                 gstreamer-1.0/libgstnvcompositor.so gstreamer-1.0/libgstnveglglessink.so
	use gstreamer || rm -rv gstreamer-1.0 tegra/libnvdsbufferpool.so*
	use vulkan    || rm -v tegra/lib*vulkan*so*

	use v4l       || rm -r tegra/libnvv4l*.so* tegra/libv4l2*.so* tegra/libtegrav4l2.so libv4l

    #Remove useless egl stuff, we will build upstream with special patches.
    rm -v tegra/libnvidia-egl-wayland.so*
    rm -v ../../share/egl/egl_external_platform.d/nvidia_wayland.json

	if use v4l; then
		#Remove in favor of our in tree built version
		rm -v tegra/libnvv4l*.so*
		rm -v libv4lconvert.so*
		rm -v libv4l2.so*
		rm -r libv4l
		mkdir -p libv4l/plugins
		mv tegra/libv4l2_nvvideocodec.so libv4l/plugins/
		mv tegra/libv4l2_nvvidconv.so libv4l/plugins/
		mv tegra/libv4l2_nvargus.so libv4l/plugins/
		mv tegra/libtegrav4l2.so ./
	fi

	rm -v "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf
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
	# Basic files
	insinto /etc/ld.so.conf.d && doins etc/ld.so.conf.d/nvidia-tegra.conf
	dobin usr/bin/nvidia-bug-report-tegra.sh
	insinto /lib/udev/rules.d && doins etc/udev/rules.d/99-tegra-devices.rules

	# Install all libs
	my_do_lib_recursive usr/lib/aarch64-linux-gnu/ usr/lib64

	# Just nvcam
	insinto /var/nvidia && doins -r var/nvidia/nvcam

	# Missed soname links
	dosym libcuda.so.1.1 /usr/lib64/tegra/libcuda.so.1
	dosym libnvidia-ptxjitcompiler.so.440.18 /usr/lib64/tegra/libnvidia-ptxjitcompiler.so.1
	dosym libdrm_nvdc.so /usr/lib64/libdrm.so.2

	#EGL Config
	dosym /usr/lib64/tegra-egl/nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

	if use alsa; then
		insinto /etc
		doins etc/asound.conf.tegrasndt210ref
		doins etc/asound.conf.tegrahda

		insinto /lib/udev/rules.d
		doins etc/udev/rules.d/92-hdmi-audio-tegra.rules

		insinto /usr/share
		doins -r usr/share/alsa
	fi

	if use doc; then
		dodoc -r /usr/share/doc
	fi

	if use firmware; then
		insinto /lib
		doins -r lib/firmware || die "Install failed!"
		insinto /lib/firmware
		newins "${DISTDIR}"/tegra210b01_xusb_firmware-"${MARIKO_FIRMWARE_VERSION}".bin tegra210b01_xusb_firmware
		dosym /lib/firmware/tegra21x/nv_acr_ucode_prod.bin /lib/firmware/tegra21x/acr_ucode.bin
		dosym /lib/firmware/tegra21x/nv_acr_ucode_prod.bin /lib/firmware/gm20b/acr_ucode.bin
	fi

	if use usb-device; then
		insinto /lib/udev/
		doins etc/udev/rules.d/99-nv-l4t-usb-device-mode.rules
		exeinto /opt/nvidia/l4t-usb-device-mode
		doexe opt/nvidia/l4t-usb-device-mode/*.sh
		insinto /opt/nvidia/l4t-usb-device-mode
		doins opt/nvidia/l4t-usb-device-mode/LICENSE.filesystem.img
	fi

	if use vulkan; then
		dosym /usr/lib64/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
	fi

	if use X; then
		insinto /usr/lib64
		doins -r usr/lib/xorg
		dosym /usr/lib64/tegra /usr/lib64/opengl/nvidia/lib
		insinto /etc/X11/xorg.conf.d && newins etc/X11/xorg.conf 30-jetson-tx1-drivers.conf
	fi
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	ldconfig
	if use pulseaudio && ! [[ -f /etc/asound.conf ]]; then
               einfo "No /etc/asound.conf found, create default Pulseaudio asound.conf"
               cat << EOF >> /etc/asound.conf
# This file is referred to from files in /usr/share/alsa/alsa.conf.d/ in order
# to set up the pulse device as the default if required.

pcm.!default {
        type pulse
}

ctl.!default {
        type pulse
}
EOF

	elif use alsa && ! [[ -f /etc/asound.conf ]]; then
		einfo "No /etc/asound.conf found, create symlink to /etc/asound.conf.tegrasndt210ref"
		ln -s /etc/asound.conf.tegrasndt210ref /etc/asound.conf
	fi
	udev_reload
}

