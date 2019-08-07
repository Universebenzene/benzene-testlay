# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

DESCRIPTION="Baidu Net Disk is a cloud storage client (Linux Version)"
HOMEPAGE="https:/pan.baidu.com"
SRC_URI="https://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/${PN}_linux_${PV}.deb"

LICENSE=""
SLOT="0"
RESTRICT="strip"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/gtk+
	x11-libs/libXScrnSaver
	dev-libs/nss
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

PATCHES=( "${FILESDIR}" )

src_install() {
	unpack usr/share/doc/${PN}/*.gz
	rm -r usr/share/doc || die
	local DOCS=( changelog )

	insinto /usr
	doins -r usr/share

	insinto /opt
	doins -r opt/${PN}
	fperms +x /opt/${PN}/${PN}

	newbin ${FILESDIR}/${PN}-wrapper.sh ${PN}
	default
}
