# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="YouDao Console Version - Simple wrapper for Youdao online translate service API"
HOMEPAGE="https://github.com/felixonmars/ydcv"
SRC_URI="https://github.com/felixonmars/ydcv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pkginfo"

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm
	pkginfo? (
		dev-python/setuptools-markdown
		dev-python/pypandoc
		dev-python/wheel
		dev-python/pip
	)
"

BDEPEND=""

python_prepare_all() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
	use pkginfo || eapply "${FILESDIR}/${PN}-disable_setuptools_markdown.patch"

	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=( README.md )

	insinto /usr/share/zsh/site-functions
	newins contrib/zsh_completion _${PN}

	distutils-r1_python_install_all
}
