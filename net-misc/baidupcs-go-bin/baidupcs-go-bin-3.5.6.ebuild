# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="BaiduPCS-Go"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="The terminal utility for Baidu Network Disk (Golang Version)."
HOMEPAGE="https://github.com/iikira/BaiduPCS-Go"
SRC_URI="
	amd64? ( https://github.com/iikira/${MY_PN}/releases/download/v${PV}/${MY_P}-linux-amd64.zip )
	x86? ( https://github.com/iikira/${MY_PN}/releases/download/v${PV}/${MY_P}-linux-386.zip )
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!net-misc/baidupcs-go
"
BDEPEND=""

S=${WORKDIR}/${MY_P}-linux-${ARCH}

src_install() {
	default
	newbin ${MY_PN} ${PN%-bin}
}
