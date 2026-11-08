EAPI="8"
KEYWORDS="arm64"
SLOT="0"

HOMEPAGE="https://gitlab.com/switchroot/bootstack/switch-atf"
DESCRIPTION="Switchroot's Trusted Firmware-A for the Switch (bl31.bin for hekate)"
LICENSE="BSD"

inherit git-r3 sdcard-mount toolchain-funcs

EGIT_REPO_URI="https://gitlab.com/switchroot/bootstack/switch-atf.git"
EGIT_BRANCH="switch-v4-atf2.6"
# the commit Lakka builds (projects/L4T/devices/Switch/packages/switch-atf)
EGIT_COMMIT="8902c539ce83b15637c5f47fc8aff5d14d95b992"

BDEPEND="sys-apps/dtc"
# older bootstacks shipped prebuilt bl31.bin and bl33.bin
RDEPEND="!<sys-boot/switchroot-bootstack-20260327-r1"

src_compile() {
	# firmware: not built with the system's flags. The settings are
	# Lakka's; --no-warn-rwx-segments for binutils 2.39+, which warns
	# about bl31's segment and TF-A 2.6 links with --fatal-warnings
	# (TF-A added the same in 2.8)
	env -u CPPFLAGS -u CXXFLAGS -u ASFLAGS \
		ARCH=arm64 \
		LDFLAGS="--emit-relocs --no-warn-rwx-segments" \
		CFLAGS="-fno-pic -fno-stack-protector -Wno-deprecated-declarations -Wno-unused-function" \
		emake CROSS_COMPILE="${CHOST}-" HOSTCC="$(tc-getBUILD_CC)" \
			PLAT=tegra \
			TARGET_SOC=t210 \
			TZDRAM_BASE=0xFFF00000 \
			RESET_TO_BL31=1 \
			COLD_BOOT_SINGLE_CPU=1 \
			PROGRAMMABLE_RESET_ADDRESS=1 \
			ENABLE_STACK_PROTECTOR=none \
			SDEI_SUPPORT=0 \
			CRASH_REPORTING=1 \
			ENABLE_ASSERTIONS=1 \
			LOG_LEVEL=0 \
			PLAT_LOG_LEVEL_ASSERT=0 \
			bl31
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	doins build/tegra/t210/release/bl31.bin
}
