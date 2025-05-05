# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#DISTUTILS_USE_SETUPTOOLS=no
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/portage.git"
#	https://gitweb.gentoo.org/proj/portage.git/tree/?id=605ad0d675a64eb39144122cf284100192cdfea0
	S="${WORKDIR}/${P}/repoman"
else
	SRC_URI="https://dev.gentoo.org/~zmedico/portage/archives/${P}.tar.bz2
		https://github.com/gentoo/portage/compare/285d3ae987a079f32b909c6e6eddde9bc45a4a25...b09b4071151d8e3a81f3576843d00f88eb407799.patch -> ${P}-unit-test-bug-779055.patch
		https://github.com/gentoo/portage/commit/e29177fcd2950199afa4f83673c0771afb261123.patch -> ${P}-version-bug-779508.patch
		https://github.com/gentoo/portage/commit/2eb3ca092a528e0722e0ca32f616836ed8039936.patch -> ${P}-unit-test-bug-779967.patch"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Repoman is a Quality Assurance tool for Gentoo ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=sys-apps/portage-3.0.18[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
#	<sys-apps/portage-3.0.31[${PYTHON_USEDEP}]

python_prepare_all() {
	local patches=(
		"${DISTDIR}/${P}-unit-test-bug-779055.patch"
		"${DISTDIR}/${P}-version-bug-779508.patch"
		"${DISTDIR}/${P}-unit-test-bug-779967.patch"
	)
	eapply -p2 "${patches[@]}"
	eapply "${FILESDIR}/${P}-fix-portage-3.0.65.patch"
	eapply "${FILESDIR}/${P}-fix-portage-3.0.67.patch"

	distutils-r1_python_prepare_all
}

python_test() {
	unset REPOMAN_DEFAULT_OPTS
	esetup.py test
}

python_install() {
	# Install sbin scripts to bindir for python-exec linking
	# they will be relocated in pkg_preinst()
	rm -r "${BUILD_DIR}"/install/$(python_get_sitedir)/usr || die
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--mandir="${EPREFIX}/usr/share/man" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
	python_doexe bin/*
}

python_install_all() {
	DOCS=( NEWS README RELEASE-NOTES )
	doman man/*
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog ""
		elog "This release of repoman is from the new portage/repoman split"
		elog "release code base."
		elog "This new repoman code base is still being developed.  So its API's"
		elog "are not to be considered stable and are subject to change."
		elog "The code released has been tested and considered ready for use."
		elog "This however does not guarantee it to be completely bug free."
		elog "Please report any bugs you may encounter."
		elog ""
	fi
}
