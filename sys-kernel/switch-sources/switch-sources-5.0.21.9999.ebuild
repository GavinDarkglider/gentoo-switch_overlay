# Copyright 1999-2019 Alexander Weber
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~arm64"

HOMEPAGE="https://github.com/bell07/bashscripts-switch_gentoo
         https://gitlab.com/switchroot/linux-switch"

IUSE="experimental"

K_DEFCONFIG="nintendo_switch_defconfig"
K_SECURITY_UNSUPPORTED="yes"

K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="22"
UNIPATCH_STRICTORDER="yes"

inherit kernel-2
detect_version
detect_arch
inherit git-r3

DESCRIPTION="Nintendo Switch kernel sources for the ${KV_MAJOR}.${KV_MINOR} switchroot tree with gentoo patches"
SRC_URI="${GENPATCHES_URI}"

EGIT_REPO_URI="https://gitlab.com/switchroot/linux-switch.git"
EGIT_BRANCH="switch-${KV_MAJOR}.${KV_MINOR}"
EGIT_CHECKOUT_DIR="${S}"

src_unpack() {
	git-r3_src_unpack

	handle_genpatches --set-unipatch-list
	cd "${S}"
	unipatch "${UNIPATCH_LIST_GENPATCHES}"
	unpack_set_extraversion
	rm -Rf "${S}"/.git
}
