# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Automatic generate WM menu from xdg files"
HOMEPAGE="https://wiki.archlinux.org/index.php/XdgMenu"
SRC_URI="https://arch.p5n.pp.ru/~sergej/dl/2023/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/XML-Parser"

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
