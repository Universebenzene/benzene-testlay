# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="BaiduPCS-Go"
EGO_PN="github.com/iikira/${MY_PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-build golang-vcs
else
	EGO_VENDOR=( "${EGO_PN} v${PV}" )

	inherit golang-build golang-vcs-snapshot

	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_VENDOR_URI}"
	KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~mips"
fi

DESCRIPTION="The terminal utility for Baidu Network Disk (Golang Version)."
HOMEPAGE="https://github.com/iikira/BaiduPCS-Go"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!net-misc/baidupcs-go-bin
"
BDEPEND=""

src_prepare() {
	rm -r "src/${EGO_PN}/vendor/${EGO_PN}" || die
	default
}

src_install() {
	newbin ${MY_PN} baidupcs-go
	dodoc "src/${EGO_PN}/README.md"
}
