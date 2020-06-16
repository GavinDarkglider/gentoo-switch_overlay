EAPI=6
KEYWORDS="~arm64"
SLOT="0"

HOMEPAGE="https://www.coreboot.org/CBFS"
DESCRIPTION="Tools to manipulate coreboot CBFS"
SRC_URI="https://coreboot.org/releases/coreboot-${PV}.tar.xz"

S="${WORKDIR}/coreboot-${PV}/util/cbfstool"
export PREFIX="/usr"
