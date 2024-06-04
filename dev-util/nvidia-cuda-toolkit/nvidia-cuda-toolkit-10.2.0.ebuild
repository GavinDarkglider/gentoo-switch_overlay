# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs toolchain-funcs unpacker

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
MY_PV="$(ver_cut 1-2)"
M_PV="${MY_PV//\./-}"
SRC_URI="https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-command-line-tools-${M_PV}/cuda-command-line-tools-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-compiler-${M_PV}/cuda-compiler-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cudart/cuda-cudart-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cudart/cuda-cudart-dev-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cuobjdump/cuda-cuobjdump-${M_PV}_10.2.300-1_arm64.deb
	profiler? (
		https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cupti/cuda-cupti-${M_PV}_10.2.300-1_arm64.deb
		https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cupti/cuda-cupti-dev-${M_PV}_10.2.300-1_arm64.deb
	)
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-documentation/cuda-documentation-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-cudart/cuda-driver-dev-${M_PV}_10.2.300-1_arm64.deb
	debugger? (
		https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-gdb/cuda-gdb-${M_PV}_10.2.300-1_arm64.deb
		https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-gdb/cuda-gdb-src-${M_PV}_10.2.300-1_arm64.deb
	)
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-libraries-${M_PV}/cuda-libraries-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-libraries-dev-${M_PV}/cuda-libraries-dev-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-memcheck/cuda-memcheck-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-minimal-build-${M_PV}/cuda-minimal-build-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvcc/cuda-nvcc-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvdisasm/cuda-nvdisasm-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvgraph/cuda-nvgraph-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvgraph/cuda-nvgraph-dev-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvml-dev/cuda-nvml-dev-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvprof/cuda-nvprof-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvprune/cuda-nvprune-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvrtc/cuda-nvrtc-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvrtc/cuda-nvrtc-dev-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-nvtx/cuda-nvtx-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-samples/cuda-samples-${M_PV}_10.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-toolkit-${M_PV}/cuda-toolkit-${M_PV}_10.2.460-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-tools-${M_PV}/cuda-tools-${M_PV}_10.2.460-1_arm64.deb
	vis-profiler? ( https://repo.download.nvidia.com/jetson/common/pool/main/c/cuda-visual-tools-${M_PV}/cuda-visual-tools-${M_PV}_10.2.460-1_arm64.deb )
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcublas/libcublas-dev_10.2.3.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcublas/libcublas10_10.2.3.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcufft/libcufft-${M_PV}_10.1.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcufft/libcufft-dev-${M_PV}_10.1.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcurand/libcurand-${M_PV}_10.1.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcurand/libcurand-dev-${M_PV}_10.1.2.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcusolver/libcusolver-${M_PV}_10.3.0.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcusolver/libcusolver-dev-${M_PV}_10.3.0.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcusparse/libcusparse-${M_PV}_10.3.1.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libc/libcusparse/libcusparse-dev-${M_PV}_10.3.1.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libn/libnpp/libnpp-${M_PV}_10.2.1.300-1_arm64.deb
	https://repo.download.nvidia.com/jetson/common/pool/main/libn/libnpp/libnpp-dev-${M_PV}_10.2.1.300-1_arm64.deb
"
S="${WORKDIR}"

LICENSE="NVIDIA-CUDA"
SLOT="0/${PV}"
KEYWORDS="-* ~arm64"
IUSE="debugger profiler vis-profiler"
RESTRICT="bindist mirror"

# since CUDA 11, the bundled toolkit driver (== ${DRIVER_PV}) and the
# actual required minimum driver version are different. Lowering the
# bound helps Kepler sm_35 and sm_37 users.
# https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#cuda-major-component-versions
RDEPEND="
	sys-devel/gcc:8.5.0[cxx]
	>=sys-libs/jetson-tx1-drivers-32.7.0
	vis-profiler? (
		>=virtual/jre-1.8:*
	)"

QA_PREBUILT="opt/cuda/*"
CHECKREQS_DISK_BUILD="6800M"

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	# ATTENTION: change requires revbump
	local cuda_supported_gcc="8.5"

    sed \
        -e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
        "${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	default
}

src_install() {
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}${cudadir}"
	local pathextradirs ldpathextradirs
	dodir ${cudadir}
	into ${cudadir}

	local builddirs=(
		usr/local/cuda-${MY_PV}
	)

	local d f
	for d in "${builddirs[@]}"; do
		ebegin "Installing ${d}"
		[[ -d ${d} ]] || die "Directory does not exist: ${d}"

		if [[ -d ${d}/bin ]]; then
			for f in ${d}/bin/*; do
				if [[ -f ${f} ]]; then
					dobin "${f}"
				else
					insinto ${cudadir}/bin
					doins -r "${f}"
				fi
			done
		fi

		insinto ${cudadir}
		if [[ -d ${d}/targets ]]; then
			doins -r "${d}"/targets
		fi
		if [[ -d ${d}/share ]]; then
			doins -r "${d}"/share
		fi
		if [[ -d ${d}/extras ]]; then
			doins -r "${d}"/extras
		fi
		eend $?
	done
	dobin "${T}"/cuda-config

	doins usr/local/cuda-${MY_PV}/EULA.txt
	# nvml and nvvm need special handling
	ebegin "Installing nvvm"
	doins -r usr/local/cuda-${MY_PV}/nvvm
	fperms +x ${cudadir}/nvvm/bin/cicc
	eend $?

	ebegin "Installing nvml"
	doins -r usr/local/cuda-${MY_PV}/nvml
	eend $?

	# Add include and lib symlinks
	dosym targets/aarch64-linux/include ${cudadir}/include
	dosym ${cudadir}/include/thrust/system/cuda/detail/cub ${cudadir}/include/cub
	dosym targets/aarch64-linux/lib ${cudadir}/lib64

	if use debugger; then
		doheader ${ecudadir}/extras/Debugger/include/*.h
		ldpathextradirs+=":${ecudadir}/extras/Debugger/lib64"
	fi

	newenvd - 99cuda <<-EOF
		PATH=${ecudadir}/bin${pathextradirs}
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib64:${ecudadir}/nvvm/lib64${ldpathextradirs}
	EOF

	# Cuda prepackages libraries, don't revdep-build on them
	insinto /etc/revdep-rebuild
	newins - 80${PN} <<-EOF
		SEARCH_DIRS_MASK="${ecudadir}"
	EOF

	# https://bugs.gentoo.org/926116
    insinto /etc/sandbox.d
	newins - 80${PN} <<-EOF
        SANDBOX_PREDICT="/proc/self/task"
	EOF
}

pkg_postinst_check() {
    local a="$("${EROOT}"/opt/cuda/bin/cuda-config -s)"
    local b="0.0"
    local v
    for v in ${a}; do
        ver_test "${v}" -gt "${b}" && b="${v}"
    done

    # if gcc and if not gcc-version is at least greatest supported
    if tc-is-gcc && \
        ver_test $(gcc-version) -gt "${b}"; then
            ewarn
            ewarn "gcc > ${b} will not work with CUDA"
            ewarn "Make sure you set an earlier version of gcc with gcc-config"
            ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
            ewarn "--compiler-bindir=${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${b}"
            ewarn "to the nvcc compiler flags"
            ewarn
    fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi

    einfo
    einfo "You'll need to add the following line to "
    einfo "a modprobe configuration file "
    einfo "(e.g. /etc/modprobe.d/nvidia-prof.conf): "
    einfo
    einfo "options tegra-udrm modeset=1"
    einfo
	einfo "You'll also need to enable the GPU by: "
	einfo
	einfo "echo 1 > /sys/devices/57000000.gpu/allow_all"
	einfo

}

