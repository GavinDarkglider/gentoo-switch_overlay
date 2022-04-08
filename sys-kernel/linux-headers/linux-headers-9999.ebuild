# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="arm64"

SWITCHROOT_VER="linux-3.4.1-dev"
NVIDIA_VER="l4t/l4t-r32.5"

EXTRAVERSION=".341-l4t-gentoo-dist"
KV_LOCALVERSION="-l4t-gentoo-dist"

inherit kernel-2 git-r3

KEYWORDS="-* arm64"

# bug #816762
RESTRICT="test"

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/switchroot/kernel/l4t-kernel-4.9"
	EGIT_BRANCH="${SWITCHROOT_VER}"
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack
	rm -Rf "${S}"/.git*
}

src_prepare() {
	eapply "${FILESDIR}"/06-Revert-arm64-32bit-sigcontext-definition-to-uapi-signcontext.h.patch

	# avoid kernel-2_src_prepare
	default
}

src_test() {
	emake headers_check ${xmakeopts}
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die
}
