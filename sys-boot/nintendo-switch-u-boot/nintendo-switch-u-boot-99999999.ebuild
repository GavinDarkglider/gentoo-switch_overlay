EAPI="8"
KEYWORDS="arm64"
SLOT="0"

PYTHON_COMPAT=( python3_{12..15} )

HOMEPAGE="https://gitlab.com/switchroot/switch-uboot"
DESCRIPTION='"Das U-Boot" Source Tree for the Switch'

inherit git-r3 python-any-r1 sdcard-mount toolchain-funcs

EGIT_REPO_URI="https://gitlab.com/switchroot/switch-uboot"
EGIT_BRANCH="linux-hekatf"
EGIT_CHECKOUT_DIR="${S}"

BDEPEND="
	${PYTHON_DEPS}
	app-alternatives/bc
	app-alternatives/lex
	app-alternatives/yacc
	dev-lang/swig
	$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
"

PATCHES=(
	"${FILESDIR}"/dtb-build.patch
	"${FILESDIR}"/pylibfdt-python-swig.patch
)

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	sdcard-mount_pkg_setup
}

uboot_emake() {
	# a bootloader: not built with the system's flags (U-Boot passes
	# LDFLAGS straight to ld)
	env -u CFLAGS -u CPPFLAGS -u CXXFLAGS -u LDFLAGS -u ASFLAGS \
		emake CROSS_COMPILE="${CHOST}-" HOSTCC="$(tc-getBUILD_CC)" \
			PYTHON="${EPYTHON}" "$@"
}

src_configure() {
	einfo "Use provided nintendo-switch_defconfig"
	uboot_emake nintendo-switch_defconfig
}

src_compile() {
	uboot_emake
}

src_install() {
	insinto "${SDCARD_DESTDIR}"/switchroot/gentoo
	newins u-boot-dtb.bin bl33.bin
}
