# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatic generate WM menu from xdg files"
HOMEPAGE="https://wiki.archlinux.org/index.php/XdgMenu"
SRC_URI="https://arch.p5n.pp.ru/~sergej/dl/2018/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/XML-Parser"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/desktop-directories
	doins -r arch-desktop-directories/*

	insinto /etc/xdg/menus
	doins -r ${PN}/*

	insinto /etc
	doins *.conf

	dobin {xdg_menu*,update-menus}
	keepdir /var/cache/${PN/arch-}
}
