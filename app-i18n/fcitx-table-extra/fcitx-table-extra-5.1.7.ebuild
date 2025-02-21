# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=fcitx5-table-extra

inherit cmake unpacker xdg

DESCRIPTION="Provides extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick"
HOMEPAGE="https://github.com/fcitx/fcitx5-table-extra"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

DEPEND="
	app-i18n/fcitx:5
	app-i18n/libime
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

src_prepare() {
	for iconn in icons/*/apps/fcitx*g; do { mv ${iconn} ${iconn%%_*}5_${iconn#*_} || die ; }; done
	sed -i "/^Icon=/s/fcitx_/fcitx5_/" tables/*conf.in* || die
	cmake_src_prepare
}
