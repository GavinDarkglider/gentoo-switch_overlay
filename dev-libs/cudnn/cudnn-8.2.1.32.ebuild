# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

BASE_V="$(ver_cut 0-3)"
CUDA_MA="10"
CUDA_MI="2"
CUDA_V="${CUDA_MA}.${CUDA_MI}"

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cudnn"
SRC_URI="https://repo.download.nvidia.com/jetson/common/pool/main/c/cudnn/libcudnn8_${PV}-1+cuda${CUDA_V}_arm64.deb
https://repo.download.nvidia.com/jetson/common/pool/main/c/cudnn/libcudnn8-dev_${PV}-1+cuda${CUDA_V}_arm64.deb"
S="${WORKDIR}"

LICENSE="NVIDIA-cuDNN"
SLOT="0/8"
KEYWORDS="-* ~arm64"
IUSE="static-libs"
RESTRICT="mirror"

RDEPEND="=dev-util/nvidia-cuda-toolkit-10*"

QA_PREBUILT="/opt/cuda/targets/aarch64-linux/lib/*"

src_install() {
	local cudadir=/opt/cuda
	dodir ${cudadir}
	into ${cudadir}

	local f
	for f in usr/lib/aarch64-linux-gnu/*.so.8*
	do
		dolib.so ${f}
	done

	if use static-libs
	then
		dolib.a usr/lib/aarch64-linux-gnu/libcudnn_static_v8.a
	fi

	insinto ${cudadir}/include
	doins -r usr/include/aarch64-linux-gnu/*.h
	for f in ${cudadir}/include/cudnn*
	do
		dosym "${f}" "${f/_v8/}"
	done
}
