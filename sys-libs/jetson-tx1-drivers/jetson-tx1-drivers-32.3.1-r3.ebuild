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
	gstreamer? ( media-libs/gst-plugins-bad
	             media-libs/gst-plugins-ugly )
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
	sed -i 's:libGLX_nvidia.so.0:/usr/lib64/libGLX_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra/nvidia_icd.json
	sed -i 's:libEGL_nvidia.so.0:/usr/lib64/libEGL_nvidia.so.0:g' usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json
	sed -i 's:libnvidia-egl-wayland.so.1:/usr/lib64/libnvidia-egl-wayland.so.1:g' usr/share/egl/egl_external_platform.d/nvidia_wayland.json

	# All files in /usr/lib/aarch64-linux-gnu are installed bellow. excepting the deleted at this place
	cd "${S}"/usr/lib/aarch64-linux-gnu/

	if ! use wayland; then
		rm -v tegra/libnvidia-egl-wayland.so*       # requires libwayland-client.so.0 + libwayland-server.so.0
		rm -v tegra/libnvvulkan-producer.so*        # requires libnvidia-egl-wayland.so.1
		rm -v gstreamer-1.0/libgstnveglglessink.so* # requires libwayland-client.so.0 + libwayland-server.so.0
	fi
	use gstreamer || rm -rv gstreamer-1.0 tegra/libnvdsbufferpool.so*
	use egl       || rm -rv tegra-egl
	use vulkan    || rm -v tegra/lib*vulkan*so*

	rm -v "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf

	rm -r "${S}"/lib/firmware/gm20b
	eapply_user
}


my_do_lib_recursive() {
	# $1 is the source / target path
	# $2 is the path for additional symlinks
	for f in "$1"/*; do
		if [ -h "${f}" ]; then
			target="$(readlink "${f}")"
			if [[ "$target" = /* ]]; then
				relative="$(realpath --relative-to=/"$(dirname "${f}")" /"$(dirname "$target")")"
				if [ "$relative" == '.' ]; then
					dosym "$(basename "$target")" "${f}"
				else
					dosym "$relative/$(basename "$target")" "${f}"
				fi
			else
				dosym "$target" "${f}"
			fi
			# Compatibility symlink at original location
			relative="$(realpath --relative-to="/$2" "/$1")"
			dosym "$relative/$(basename "${f}")" "$2"/"$(basename "${f}")"

		elif [ -f "${f}" ]; then
			if [ -n "$(echo "$f" | grep -e [.]so[.] -e [.]so$)" ]
			then
				insinto "$1"
				doins "${f}"
				# Compatibility symlink at original location
				relative="$(realpath --relative-to="/$2" "/$1")"
				dosym "$relative/$(basename "${f}")" "$2"/"$(basename "${f}")"
			elif [ -x "${f}" ]
			then
				exeinto "$1"
				doexe "${f}"
			else
				insinto "$1"
				doins "${f}"
			fi

		elif [ -d "${f}" ]; then
			if [ "$(basename "${f}")" == 'gstreamer-1.0' ] ; then
				my_do_lib_recursive "${f}" "${2}/gstreamer-1.0"
			else
				my_do_lib_recursive "${f}" "${2}"
				relative="$(realpath --relative-to="/$2" "/$1")"
				dosym "$relative/$(basename "${f}")" "$2"/"$(basename "${f}")"
			fi
		else
			ewarn "skipped broken file in my_do_lib_recursive ${f}"
		fi
	done
}


src_install() {
	# Basic files
	insinto /lib/udev/rules.d && doins etc/udev/rules.d/99-tegra-devices.rules

	# Install all libs
	my_do_lib_recursive usr/lib/aarch64-linux-gnu/ usr/lib64

	# Plugins in old location without symlinks
	insinto usr/lib/aarch64-linux-gnu/libv4l/plugins/
	doins -r usr/lib/aarch64-linux-gnu/libv4l/plugins/nv/

	# Missed soname links
	dosym libv4l2.so.0.0.999999 /usr/lib64/libv4l2.so.0
	dosym libv4l2.so.0 /usr/lib64/libv4l2.so
	dosym libv4lconvert.so.0.0.999999 /usr/lib64/libv4lconvert.so.0
	dosym libv4lconvert.so.0 /usr/lib64/libv4lconvert.so

	dosym libnvdsbufferpool.so.1.0.0 /usr/lib64/libnvdsbufferpool.so
	dosym libnvgbm.so /usr/lib64/libgbm.so.1

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
		dosym /usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
	fi

	if use firmware; then
		insinto /lib
		doins -r lib/firmware || die "Install failed!"
		dosym tegra21x lib/firmware/gm20b
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
		dosym /usr/lib/aarch64-linux-gnu/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
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
