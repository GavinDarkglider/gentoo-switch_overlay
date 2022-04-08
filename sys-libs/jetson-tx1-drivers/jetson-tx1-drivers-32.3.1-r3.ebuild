EAPI=7

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"

SRC_URI="https://developer.nvidia.com/embedded/dlc/r32-3-1_Release_v1.0/t210ref_release_aarch64/Tegra210_Linux_R32.3.1_aarch64.tbz2"

SLOT="0"
KEYWORDS="-* arm64"
IUSE="alsa doc +egl +firmware gstreamer usb-device vulkan wayland X"
RESTRICT="preserve-libs mirror"

DEPEND="app-arch/bzip2
	firmware? ( !!sys-firmware/jetson-tx1-firmware )"

RDEPEND="
	X? ( <x11-base/xorg-server-21 )
	egl? ( media-libs/libglvnd )
	gstreamer? ( media-plugins/gst-plugins-v4l2 )
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
	sed -i 's:libEGL_nvidia.so.0:/usr/lib64/tegra-egl/libEGL_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json
	sed -i 's:libnvidia-egl-wayland.so.1:/usr/lib64/tegra/libnvidia-egl-wayland.so.1:g' usr/share/egl/egl_external_platform.d/nvidia_wayland.json

	echo "/usr/lib64/tegra" > etc/ld.so.conf.d/nvidia-tegra.conf
	use egl && echo "/usr/lib64/tegra-egl" > etc/ld.so.conf.d/nvidia-tegra-egl.conf

	# All files in /usr/lib/aarch64-linux-gnu are installed bellow. excepting the deleted at this place
	cd "${S}"/usr/lib/aarch64-linux-gnu/

	use wayland   || rm -v tegra/libnvidia-egl-wayland.so* tegra/libnvvulkan-producer.so* \
	                 gstreamer-1.0/libgstnvcompositor.so gstreamer-1.0/libgstnveglglessink.so
	use gstreamer || rm -rv gstreamer-1.0 tegra/libnvdsbufferpool.so*
	use egl       || rm -rv tegra-egl
	use vulkan    || rm -v tegra/lib*vulkan*so*

	# avoid overlaps. The files from tegra subfolder are preferred, so the original files are ok
	rm -v libv4lconvert.so*
	rm -v libv4l2.so*

	rm -v "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf

	eapply_user
}


my_do_lib_recursive() {
	# $1 is the source path
	# $2 is the target path
	for f in "$1"/*; do
		if [ -h "${f}" ]; then
			new_target="$(readlink "${f}"| sed 's:usr/lib/aarch64-linux-gnu:usr/lib64:g')"
			new_file="$2"/"$(basename "${f}")"
			if [[ "$new_target" = /* ]]; then
				relative="$(realpath --relative-to="$(dirname "$new_file")" "$(dirname "$new_target")")"
				if [ "$relative" == '.' ]; then
					dosym "$(basename "$new_target")" "$new_file"
				else
					dosym "$relative/$(basename "$new_target")" "$new_file"
				fi
			else
				dosym "$new_target" "$new_file"
			fi

			# Compatibility symlink at original location
			insinto "$1"
			relative="$(realpath --relative-to="/$1" "/$2")"
			dosym "$relative/$(basename "${f}")" "${f}"
		elif [ -f "${f}" ]; then
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

			# Compatibility symlink at original location
			insinto "$1"
			relative="$(realpath --relative-to="/$1" "/$2")"
			dosym "$relative/$(basename "${f}")" "${f}"

		elif [ -d "${f}" ]; then
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
	my_do_lib_recursive usr/lib/aarch64-linux-gnu/ /usr/lib64

	# Compatibility hack because of hardcoded paths
	dosym /usr/lib64/tegra/libv4l2_nvvideocodec.so usr/lib/aarch64-linux-gnu/libv4l/plugins/nv/libv4l2_nvvideocodec.so
	dosym /usr/lib64/tegra/libv4l2_nvvidconv.so usr/lib/aarch64-linux-gnu/libv4l/plugins/nv/libv4l2_nvvidconv.so

	# Just nvcam
	insinto /var/nvidia && doins -r var/nvidia/nvcam

	# Missed soname links
	dosym libnvv4lconvert.so /usr/lib64/tegra/libv4lconvert.so.0
	dosym libv4lconvert.so.0 /usr/lib64/tegra/libv4lconvert.so.0.0.999999
	dosym libnvv4l2.so /usr/lib64/tegra/libv4l2.so.0
	dosym libv4l2.so.0 /usr/lib64/tegra/libv4l2.so.0.0.999999
	dosym libnvgbm.so /usr/lib64/tegra/libgbm.so.1
	dosym libcuda.so.1.1 /usr/lib64/tegra/libcuda.so.1
	dosym libnvidia-ptxjitcompiler.so.32.3.1 /usr/lib64/tegra/libnvidia-ptxjitcompiler.so.1

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

	if use egl; then
		dosym /usr/lib64/tegra-egl/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
		insinto /etc/ld.so.conf.d && doins etc/ld.so.conf.d/nvidia-tegra-egl.conf
	fi

	if use firmware; then
		insinto /lib
		doins -r lib/firmware || die "Install failed!"
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

	if use wayland; then
		insinto usr/share/egl/egl_external_platform.d && doins usr/share/egl/egl_external_platform.d/nvidia_wayland.json
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
	if use alsa && ! [[ -f /etc/asound.conf ]]; then
		einfo "No /etc/asound.conf found, create symlink to /etc/asound.conf.tegrasndt210ref"
		ln -s /etc/asound.conf.tegrasndt210ref /etc/asound.conf
	fi
}
