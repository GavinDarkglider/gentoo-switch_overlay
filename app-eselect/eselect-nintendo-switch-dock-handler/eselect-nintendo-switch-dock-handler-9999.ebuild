EAPI=7

inherit git-r3

DESCRIPTION="Eselect module for Nintendo Switch Dock Profiles"
HOMEPAGE="https://github.com/GavinDarkglider/eselect-dockhandler"

EGIT_REPO_URI="https://github.com/GavinDarkglider/eselect-dockhandler"

SLOT="0"
KEYWORDS="-* arm64"
IUSE=""

RDEPEND="
	app-admin/eselect
	sys-libs/switch-l4t-configs[alsa]
	app-admin/sudo
"

src_install() {
	mkdir -p "${D}/usr/share/"
	mkdir -p "${D}/usr/share/eselect/modules/"
        mkdir -p "${D}/lib/udev/rules.d"
	mkdir -p "${D}/usr/bin"
	exeinto /usr/share/dock-handler/
	doexe dock-handler/*

	insinto /usr/share/eselect/modules/
	doins dock-handler.eselect

	insinto /lib/udev/rules.d
	doins 100-dp-switch.rules
}

pkg_postinst() {
	# Set the symlink if not exists
	if ! [[ -e "${EROOT}"/usr/bin/dock-hotplug ]] ; then
		einfo "set default dock-hotplug to  DH-01-Default"
		ln -s "${EROOT}"/usr/share/dock-handler/DH-01-Default "${EROOT}"/usr/bin/dock-hotplug
	fi
}

pkg_postrm() {
	# Remove symlink if not valid anymore (if uninstalled for example)
	if [[ -h "${EROOT}"/usr/bin/dock-hotplug ]]  && ! [[ -e "$(readlink "${EROOT}"/usr/bin/dock-hotplug )" ]]; then
		einfo "remove invalid dock-hotplug link"
		rm "${EROOT}"/usr/bin/dock-hotplug
	fi
}
