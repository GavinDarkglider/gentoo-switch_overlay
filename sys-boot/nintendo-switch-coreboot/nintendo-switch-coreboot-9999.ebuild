# Copyright 1999-2020 Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI=6
KEYWORDS="" #Does not build anymore :-(
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/bootstack/switch-coreboot"
DESCRIPTION="Coreboot for Nintendo Switch"

inherit multiprocessing git-r3 sdcard-mount

EGIT_REPO_URI="https://gitlab.com/switchroot/bootstack/switch-coreboot"
EGIT_BRANCH="switch-linux"

IUSE="cbfstool"

DEPEND="sys-boot/nintendo-switch-u-boot
	cbfstool? ( !sys-boot/cbfstool )
	!sys-boot/switchroot-bootstack"

#### Cut from util/crossgcc/buildgcc
# GCC toolchain version numbers
GMP_VERSION=6.1.2
MPFR_VERSION=3.1.5
MPC_VERSION=1.0.3
GCC_VERSION=6.3.0
GCC_AUTOCONF_VERSION=2.69
BINUTILS_VERSION=2.29.1
GDB_VERSION=8.0
IASL_VERSION=20161222
PYTHON_VERSION=3.5.1
EXPAT_VERSION=2.2.1
# CLANG version number
CLANG_VERSION=4.0.0
MAKE_VERSION=4.2.1
CMAKE_VERSION=3.9.0-rc3

# GCC toolchain archive locations
# These are sanitized by the jenkins toolchain test builder, so if
# a completely new URL is added here, it probably needs to be added
# to the jenkins build as well, or the builder won't download it.
GMP_ARCHIVE="https://ftpmirror.gnu.org/gmp/gmp-${GMP_VERSION}.tar.xz"
MPFR_ARCHIVE="https://ftpmirror.gnu.org/mpfr/mpfr-${MPFR_VERSION}.tar.xz"
MPC_ARCHIVE="https://ftpmirror.gnu.org/mpc/mpc-${MPC_VERSION}.tar.gz"
GCC_ARCHIVE="https://ftpmirror.gnu.org/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2"
BINUTILS_ARCHIVE="https://ftpmirror.gnu.org/binutils/binutils-${BINUTILS_VERSION}.tar.xz"
GDB_ARCHIVE="https://ftpmirror.gnu.org/gdb/gdb-${GDB_VERSION}.tar.xz"
IASL_ARCHIVE="https://acpica.org/sites/acpica/files/acpica-unix2-${IASL_VERSION}.tar.gz"
PYTHON_ARCHIVE="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz"
EXPAT_ARCHIVE="https://downloads.sourceforge.net/sourceforge/expat/expat-${EXPAT_VERSION}.tar.bz2"
# CLANG toolchain archive locations
LLVM_ARCHIVE="https://releases.llvm.org/${CLANG_VERSION}/llvm-${CLANG_VERSION}.src.tar.xz"
CFE_ARCHIVE="https://releases.llvm.org/${CLANG_VERSION}/cfe-${CLANG_VERSION}.src.tar.xz"
CRT_ARCHIVE="https://releases.llvm.org/${CLANG_VERSION}/compiler-rt-${CLANG_VERSION}.src.tar.xz"
CTE_ARCHIVE="https://releases.llvm.org/${CLANG_VERSION}/clang-tools-extra-${CLANG_VERSION}.src.tar.xz"
MAKE_ARCHIVE="https://ftpmirror.gnu.org/make/make-${MAKE_VERSION}.tar.bz2"
CMAKE_ARCHIVE="https://cmake.org/files/veb3.9/cmake-${CMAKE_VERSION}.tar.gz"
#### Cut from util/crossgcc/buildgcc end

SRC_URI="${GMP_ARCHIVE}
	${MPFR_ARCHIVE}
	${MPC_ARCHIVE}
	${GCC_ARCHIVE}
	${BINUTILS_ARCHIVE}
	${IASL_ARCHIVE}"

src_unpack() {
	git-r3_src_unpack
	mkdir "${WORKDIR}"/switch-uboot
	cp "$ROOT"/usr/share/u-boot/u-boot.elf "${WORKDIR}"/switch-uboot/u-boot.elf
	mkdir -p "${S}"/util/crossgcc/tarballs/
	cp -v "${DISTDIR}"/* "${S}"/util/crossgcc/tarballs/
}

src_compile() {
	emake crossgcc-aarch64 CPUS=$(makeopts_jobs)
	emake crossgcc-arm CPUS=$(makeopts_jobs)
	emake iasl CPUS=$(makeopts_jobs)
	emake nintendo_switch_defconfig
	emake all CPUS=$(makeopts_jobs)
}

src_install() {
	dodir "${SDCARD_DESTDIR}"/switchroot/gentoo
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins build/coreboot.rom

	if use cbfstool; then
		dobin build/util/cbfstool/fmaptool
		dobin build/util/cbfstool/ifwitool
		dobin build/util/cbfstool/rmodtool
		dobin build/util/cbfstool/cbfstool
	fi

	dobin "${FILESDIR}"/update-coreboot.sh
}

pkg_config() {
	if [ -f /usr/share/u-boot/u-boot.elf ]; then
		einfo "Write Image /usr/share/u-boot/u-boot.elf to the coreboot.bin"
		einfo "${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf
		"${ROOT}"/usr/bin/update-coreboot.sh "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${ROOT}"/usr/share/u-boot/u-boot.elf  || die "patching coreboot failed"
	else
		ewarn "No u-boot.elf file found, skip updating coreboot"
	fi

	sdcard-mount_pkg_setup

	if [[ -n "${SDCARD_MOUNT_POINT}" ]] ; then
		cp -va "${ROOT}"/"${SDCARD_DESTDIR}"/switchroot/gentoo/coreboot.rom "${SDCARD_MOUNT_POINT}"/switchroot/gentoo || die "Pls. check if right medium mounted"
	fi
}

pkg_postinst() {
	einfo "Update the u-boot in coreboot.rom using "
	einfo "   ebuild /var/db/repos/switch_overlay/sys-boot/nintendo-switch-coreboot/nintendo-switch-coreboot-9999.ebuild config"
}
