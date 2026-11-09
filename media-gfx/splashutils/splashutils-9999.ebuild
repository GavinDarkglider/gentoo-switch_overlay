# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="Framebuffer splash utilities: fbsplash silent splash and fbcondecor helper"
HOMEPAGE="https://github.com/GavinDarkglider/fbsplash"
EGIT_REPO_URI="https://github.com/GavinDarkglider/fbsplash.git"
EGIT_BRANCH="revive"

LICENSE="GPL-2"
SLOT="0"
IUSE="+fbcondecor gpm mng +png +truetype"

# The kernel helper runs from the initramfs before anything else is
# available, so it is linked statically.  freetype's own optional
# dependencies (bzip2, brotli, harfbuzz, png) need static libraries too
# when enabled; configure checks that the static link works.
RDEPEND="
	sys-apps/openrc:=
	gpm? ( sys-libs/gpm )
	mng? ( media-libs/libmng:= )
	truetype? ( media-fonts/font-bh-ttf )
"
DEPEND="${RDEPEND}
	media-libs/libjpeg-turbo:=[static-libs]
	png? (
		media-libs/libpng:=[static-libs]
		sys-libs/zlib[static-libs]
	)
	truetype? ( media-libs/freetype:2[static-libs] )
"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}/core"

src_prepare() {
	# Vol- switches to verbose mode on the Switch, which has no F2
	cd "${WORKDIR}/${P}" || die
	eapply "${FILESDIR}"/splashutils-switch-volume-down.patch

	cd "${S}" || die
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-essential-prefix=/
		--with-themedir=/etc/splash
		$(use_enable fbcondecor)
		$(use_with gpm)
		$(use_with mng)
		$(use_with png)
		$(use_with truetype ttf)
		$(use_with truetype ttf-kernel)
		# libmng has no static archive to link fbsplashctl against;
		# the plugin then starts the regular /usr/sbin/fbsplashd.
		$(use_enable !mng static-binaries)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	# OpenRC plugin, built against the libfbsplash from this tree.
	emake -C "${WORKDIR}/${P}/gentoo" \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS} -I${S}/src" \
		LDFLAGS="${LDFLAGS} -L${S}/src/.libs" \
		splash.so
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	emake -C "${WORKDIR}/${P}/gentoo" DESTDIR="${D}" install

	newinitd "${WORKDIR}/${P}/gentoo/init-fbcondecor" fbcondecor
	newconfd "${WORKDIR}/${P}/gentoo/fbcondecor.conf" fbcondecor
	insinto /etc/conf.d
	newins "${WORKDIR}/${P}/gentoo/splash.conf" splash

	keepdir /lib/splash/{cache,proc,sys}
	keepdir /etc/splash

	# Default font for themes that don't name one (Luxi Sans Oblique).
	if use truetype; then
		local font
		font=$(find "${ESYSROOT}"/usr/share/fonts -name luxisri.ttf -print -quit) || die
		[[ -n ${font} ]] || die "luxisri.ttf not found (media-fonts/font-bh-ttf)"
		dosym -r "${font#"${ESYSROOT}"}" /etc/splash/luxisri.ttf
	fi
}

pkg_postinst() {
	elog "The silent splash and the fbcondecor helper follow the framebuffer"
	elog "console rotation (fbcon=rotate:N).  Verbose (fbcondecor) backgrounds"
	elog "need a kernel with the rotation-aware fbcondecor patch."
	elog
	elog "To add the helper and a theme to an existing initramfs (e.g. from"
	elog "dracut):  splash_geninitramfs -a /boot/initramfs-<version>.img <theme>"
}
