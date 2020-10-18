EAPI=6

inherit versionator

DESCRIPTION="NVIDIA Jetson TX1 Accelerated Graphics Driver"
HOMEPAGE="https://developer.nvidia.com/embedded/linux-tegra"
MY_P="Tegra210_Linux_R${PV}"
SRC_URI="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.2/t210ref_release_aarch64/Tegra210_Linux_R32.4.2_aarch64.tbz2"
SLOT="0"
KEYWORDS="-* arm64"
IUSE="+egl +firmware gstreamer vulkan wayland X"
RESTRICT="preserve-libs mirror"

DEPEND=">=app-arch/bzip2-1.0.8"

RDEPEND="
	X? ( =x11-base/xorg-server-1.19.6
		egl? ( media-libs/libglvnd ) )
	firmware? ( !sys-firmware/jetson-tx1-firmware )
	gstreamer? ( media-libs/gst-plugins-base )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"

QA_TEXTRELS_arm64="usr/lib64/tegra/libnvidia-eglcore.so.${PV}
	usr/lib64/tegra/libnvidia-glcore.so.${PV}
	usr/lib64/tegra/libcuda.so.1.1
	usr/lib64/tegra/libGL.so.1"

S="${WORKDIR}/Linux_for_Tegra/nv_tegra"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	unpack "${WORKDIR}"/Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2
}

src_prepare() {
	sed -i -e 's:^/usr/lib/:/usr/'"lib64"'/:' "${S}"/etc/ld.so.conf.d/nvidia-tegra.conf

	if use X; then
		if use egl; then
			mv "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/*.so.? "${S}"/usr/lib/aarch64-linux-gnu/tegra/
			mv "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl/nvidia.json "${S}"/usr/lib/aarch64-linux-gnu/tegra/
		fi
	else
		if use egl; then
			ewarn "Ignoring USE=egl because USE=X is not set"
		fi
	fi

	rm -rf "${S}"/usr/lib/aarch64-linux-gnu/tegra-egl

	use wayland   || rm "${S}"/usr/lib/aarch64-linux-gnu/tegra/libnvidia-egl-wayland.so
	use vulkan    || rm "${S}"/usr/lib/aarch64-linux-gnu/tegra/libnvvulkan-producer.so
	use gstreamer || rm "${S}"/usr/lib/aarch64-linux-gnu/tegra/libnvdsbufferpool.so.1.0.0

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
	insinto "/etc" && doins "${S}/etc/nv_tegra_release"

	insinto "/etc/ld.so.conf.d" && doins "${S}/etc/ld.so.conf.d/nvidia-tegra.conf"

	dobin "${S}""/usr/bin/nvidia-bug-report-tegra.sh"

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

	if use X; then
		my_do_lib_recursive  "usr/lib/xorg/" "/usr/lib64/xorg/"
		dosym /usr/lib64/tegra /usr/lib64/opengl/nvidia/lib
	fi

	use egl && dosym /usr/lib64/tegra/nvidia.json /usr/share/glvnd/egl_vendor.d/10-nvidia.json
	use vulkan && dosym /usr/lib64/tegra/nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

	if use "firmware"; then
		insinto /lib
		doins -r lib/firmware || die "Install failed!"
	fi

	insinto "/" && doins -r var  || die "Install failed!"
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	ldconfig
}
