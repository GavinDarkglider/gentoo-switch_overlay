# Copyright 1999-2019 Alexander Weber
# Copyright 1999-2019 Gavin_Darkglider
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
KEYWORDS="~arm64"

SWITCHROOT_VER="rel30-rel32stack"
DTSTREE_VER="32.2"

GENTOO_PATCHES="
1500_XATTR_USER_PREFIX.patch
1520_security-apparmor-Use-POSIX-compatible-printf.patch
1701_ia64_fix_ptrace.patch
2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch
2300_enable-poweroff-on-Mac-Pro-11.patch
2900_dev-root-proc-mount-fix.patch
4400_alpha-sysctl-uac.patch
4567_distro-Gentoo-Kconfig.patch"

inherit l4t-sources
