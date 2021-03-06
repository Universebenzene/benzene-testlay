# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker systemd desktop xdg

MY_PN="SunloginClient"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sunlogin Remote Control for mobile devices, Win, Mac, Linux, etc. (GUI version)"
HOMEPAGE="https://sunlogin.oray.com/"
SRC_URI="http://dl-cdn.oray.com/sunlogin/linux/${MY_P}_amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND="app-text/aspell
	app-text/hunspell
	app-text/nuspell
	dev-libs/libappindicator:3
	dev-libs/libvoikko
	x11-apps/xhost
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}/usr"
LS="${S}/local/${PN%client}"

QA_PREBUILT="opt/${PN%client}/bin/*"

src_prepare() {
	sed -i 's#/usr/local/#/opt/#g' "${LS}"/etc/watch.sh || die
	sed -e "s#/usr/local/#/opt/#g" -e '2a\Requires=network-online.target\nAfter=network-online.target' \
		-i "${LS}"/scripts/run"${PN}".service || die
	sed -e 's#Exec=/usr/local/sunlogin/#Exec=/usr/#g' \
		-e 's#Icon=/usr/local/sunlogin/res/icon/sunlogin_client.png#Icon=sunloginclient#g' \
		-i share/applications/"${PN%client}".desktop || die
	sed -e "s#/usr/local/sunlogin\x0#/opt/sunlogin\x0\x0\x0\x0\x0\x0\x0#g" \
		-e "s#/usr/local/sunlogin/res/icon/%s.ico\x0#/opt/sunlogin/res/icon/%s.ico\x0\x0\x0\x0\x0\x0\x0#g" \
		-i "${LS}"/bin/"${PN}"
	default
}

src_install() {
	insinto /opt/"${PN%client}"
	doins -r "${LS}"/{bin,etc,res}
	fperms +x /opt/"${PN%client}"/bin/{oray_rundaemon,"${PN}"}
	dosym {/opt/"${PN%client}",usr}/bin/oray_rundaemon
	dosym {/opt/"${PN%client}",usr}/bin/"${PN}"

	newinitd "${FILESDIR}"/run"${PN}".initd run"${PN}"
	systemd_dounit "${LS}"/scripts/run"${PN}".service

	newicon -s 128 ${LS}/res/icon/sunlogin_client.png "${PN}".png
	domenu share/applications/"${PN%client}".desktop
}

pkg_postinst() {
	elog
	elog "Before using SunloginClient, you need to start its daemon:"
	elog "OpenRC:"
	elog "# /etc/init.d/runsunloginclient start"
	elog "# rc-update add runsunloginclient default"
	elog
	elog "Systemd:"
	elog "# systemctl start runsunloginclient.service"
	elog "# systemctl enable runsunloginclient.service"
	elog

	xdg_pkg_postinst
}
