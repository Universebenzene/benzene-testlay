# Copyright 2010-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="${PN/fcitx-}"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{{11..14},{13..14}t} )
#PYTHON_COMPAT=( python3_{{11..12},{13..14}{,t}} )

inherit desktop edo elisp-common multiprocessing python-any-r1 savedconfig toolchain-funcs xdg

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/google/mozc"
	EGIT_SUBMODULES=(src/third_party/japanese_usage_dictionary)
else
	MOZC_GIT_REVISION="305e9a7374254148474d067c46d55a4ee6081837"
	MOZC_DATE="${PV#*_p}"
	MOZC_DATE="${MOZC_DATE%%_p*}"

	FCITX_MOZC_GIT_REVISION="242b4f703cba27d4ff4dc123c713a478f964e001"
	FCITX_MOZC_DATE="${PV#*_p}"
	FCITX_MOZC_DATE="${FCITX_MOZC_DATE#*_p}"
	FCITX_MOZC_DATE="${FCITX_MOZC_DATE%%_p*}"

	JAPANESE_USAGE_DICTIONARY_GIT_REVISION="a4a66772e33746b91e99caceecced9a28507e925"
	JAPANESE_USAGE_DICTIONARY_DATE="20180701040110"
fi

DESCRIPTION="Mozc - Japanese input method editor"
HOMEPAGE="https://github.com/google/mozc"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="
		https://github.com/google/${MY_PN}/archive/${MOZC_GIT_REVISION}.tar.gz -> ${MY_PN}-${PV%%_p*}-${MOZC_DATE}.tar.gz
		https://github.com/hiroyuki-komatsu/japanese-usage-dictionary/archive/${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}.tar.gz -> japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${MY_PN}/${MY_PN}-2.28.5029.102-patches.tar.xz
		https://github.com/fcitx/${MY_PN}/archive/${FCITX_MOZC_GIT_REVISION}.tar.gz -> ${PN}-${PV%%_p*}-${FCITX_MOZC_DATE}.tar.gz
	"
fi

# Mozc: BSD
# src/data/dictionary_oss: ipadic, public-domain
# src/data/unicode: unicode
# japanese-usage-dictionary: BSD-2
LICENSE="BSD BSD-2 ipadic public-domain unicode"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"
IUSE="debug +gui renderer test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-build/gyp
	$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
	>=dev-libs/protobuf-3.0.0
	app-alternatives/ninja
	virtual/pkgconfig
	sys-devel/gettext
"
DEPEND="
	>=dev-cpp/abseil-cpp-20250512.0:=
	>=dev-libs/protobuf-3.0.0:=
	app-i18n/fcitx:4
	virtual/libintl
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	renderer? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gtk+:2
		x11-libs/pango
	)
	test? (
		>=dev-cpp/gtest-1.8.0
		dev-libs/jsoncpp
	)"
RDEPEND="
	>=dev-cpp/abseil-cpp-20230802.0:=[cxx17(+)]
	>=dev-libs/protobuf-3.0.0:=
	app-i18n/fcitx:4
	!app-i18n/mozc[fcitx4]
	virtual/libintl
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	renderer? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gtk+:2
		x11-libs/pango
	)
"

S="${WORKDIR}/${P}/src"

SITEFILE="50${MY_PN}-gentoo.el"

PATCHES=(
	"${WORKDIR}"/mozc-2.28.5029.102-patches
	"${FILESDIR}"/mozc-2.28.5029.102-abseil.patch
	"${FILESDIR}"/mozc-2.28.5029.102-abseil-20230802.0.patch
	"${FILESDIR}"/mozc-2.28.5029.102-abseil-20240116.patch
	"${FILESDIR}"/mozc-2.28.5029.102-abseil-20250127.patch
	"${FILESDIR}"/mozc-2.28.5029.102-abseil-20250512.patch
)

python_check_deps() {
	python_has_version "dev-python/six[${PYTHON_USEDEP}]"
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack

		local EGIT_SUBMODULES=()
		git-r3_fetch https://github.com/fcitx/mozc refs/heads/fcitx
		git-r3_checkout https://github.com/fcitx/mozc "${WORKDIR}/fcitx-mozc"
	else
		unpack ${MY_PN}-${PV%%_p*}-${MOZC_DATE}.tar.gz
		mv mozc-${MOZC_GIT_REVISION} ${P} || die

		unpack ${MY_PN}-2.28.5029.102-patches.tar.xz

		unpack japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_DATE}.tar.gz
		cp -p japanese-usage-dictionary-${JAPANESE_USAGE_DICTIONARY_GIT_REVISION}/usage_dict.txt ${P}/src/third_party/japanese_usage_dictionary || die

		unpack ${PN}-${PV%%_p*}-${FCITX_MOZC_DATE}.tar.gz
		cp -pr mozc-${FCITX_MOZC_GIT_REVISION} ${PN} || die
		rm -r mozc-${FCITX_MOZC_GIT_REVISION} || die
	fi
}

src_prepare() {
	cp -pr "${WORKDIR}/fcitx-mozc/src/unix/fcitx" unix || die
	PATCHES+=( "${FILESDIR}"/mozc-2.28.5029.102-abseil-20230802.0-fcitx4.patch )

	pushd "${WORKDIR}/${P}" > /dev/null || die
	default
	popd > /dev/null || die

	sed \
		-e "s/def GypMain(options, unused_args):/def GypMain(options, gyp_args):/" \
		-e "s/RunOrDie(gyp_command + gyp_options)/RunOrDie(gyp_command + gyp_options + gyp_args)/" \
		-e "s/RunOrDie(\[ninja/&, '-j$(makeopts_jobs "${MAKEOPTS}" 999)', '-l$(makeopts_loadavg "${MAKEOPTS}" 0)', '-v'/" \
		-i build_mozc.py || die

	local ar=($(tc-getAR))
	local cc=($(tc-getCC))
	local cxx=($(tc-getCXX))
	local ld=($(tc-getLD))
	local nm=($(tc-getNM))
	local readelf=($(tc-getREADELF))

	# Use absolute paths. Non-absolute paths are mishandled by GYP.
	ar[0]=$(type -P ${ar[0]})
	cc[0]=$(type -P ${cc[0]})
	cxx[0]=$(type -P ${cxx[0]})
	ld[0]=$(type -P ${ld[0]})
	nm[0]=$(type -P ${nm[0]})
	readelf[0]=$(type -P ${readelf[0]})

	sed \
		-e "s:<!(which ar):${ar[@]}:" \
		-e "s:<!(which clang):${cc[@]}:" \
		-e "s:<!(which clang++):${cxx[@]}:" \
		-e "s:<!(which ld):${ld[@]}:" \
		-e "s:<!(which nm):${nm[@]}:" \
		-e "s:<!(which readelf):${readelf[@]}:" \
		-i gyp/common.gypi || die

	# https://github.com/google/mozc/issues/489
	sed \
		-e "/'-lc++'/d" \
		-e "/'-stdlib=libc++'/d" \
		-i gyp/common.gypi || die

	# bug #877765
	restore_config mozcdic-ut.txt
	if [[ -f /mozcdic-ut.txt && -s mozcdic-ut.txt ]]; then
		einfo "mozcdic-ut.txt found. Adding to mozc dictionary..."
		cat mozcdic-ut.txt >> "${WORKDIR}/${P}/src/data/dictionary_oss/dictionary00.txt" || die
	fi

	# bug #960019
	sed -i "/std=c++17/s/17/20/g" gyp/common.gypi || die
}

src_configure() {
	if use debug; then
		BUILD_TYPE="Debug"
	else
		BUILD_TYPE="Release"
	fi

	local gyp_arguments=()

	if tc-is-gcc; then
		gyp_arguments+=(-D compiler_host=gcc -D compiler_target=gcc)
	elif tc-is-clang; then
		gyp_arguments+=(-D compiler_host=clang -D compiler_target=clang)
	else
		gyp_arguments+=(-D compiler_host=unknown -D compiler_target=unknown)
	fi

	gyp_arguments+=(-D debug_extra_cflags=)
	gyp_arguments+=(-D release_extra_cflags=)

	gyp_arguments+=(-D use_fcitx=YES)
#	gyp_arguments+=(-D use_fcitx5=$(usex fcitx5 YES NO))
	gyp_arguments+=(-D use_libprotobuf=1)
	gyp_arguments+=(-D use_system_abseil_cpp=1)
	gyp_arguments+=(-D use_system_gtest=$(usex test 1 0))
	gyp_arguments+=(-D use_system_jsoncpp=$(usex test 1 0))
	gyp_arguments+=(-D enable_gtk_renderer=$(usex renderer 1 0))

	gyp_arguments+=(-D server_dir="${EPREFIX}/usr/libexec/mozc")
	gyp_arguments+=(-D document_dir="${EPREFIX}/usr/libexec/mozc/documents")

	unset AR CC CXX LD NM READELF

	edo "${PYTHON}" build_mozc.py gyp \
		--gypdir="${EPREFIX}/usr/bin" \
		--server_dir="${EPREFIX}/usr/libexec/mozc" \
		--verbose \
		$(usex gui "" --noqt) \
		-- "${gyp_arguments[@]}"
}

src_compile() {
	local targets=(server/server.gyp:mozc_server)
	targets+=(unix/fcitx/fcitx.gyp:fcitx-mozc)
	if use gui; then
		targets+=(gui/gui.gyp:mozc_tool)
	fi
	if use renderer; then
		targets+=(renderer/renderer.gyp:mozc_renderer)
	fi
	if use test; then
		targets+=(gyp/tests.gyp:unittests)
	fi

	edo "${PYTHON}" build_mozc.py build -c ${BUILD_TYPE} ${GYP_IBUS_FLAG} -v "${targets[@]}"
}

src_test() {
	edo "${PYTHON}" build_mozc.py runtests -c ${BUILD_TYPE} --test_jobs 1
}

src_install() {
	exeinto /usr/libexec/mozc
	doexe out_linux/${BUILD_TYPE}/mozc_server

	[[ -s mozcdic-ut.txt ]] && save_config mozcdic-ut.txt

	if use gui; then
		doexe out_linux/${BUILD_TYPE}/mozc_tool
	fi

	if use renderer; then
		doexe out_linux/${BUILD_TYPE}/mozc_renderer
	fi

	insinto /usr/libexec/mozc/documents
	doins data/installer/credits_en.html

	exeinto /usr/$(get_libdir)/fcitx
	doexe out_linux/${BUILD_TYPE}/fcitx-mozc.so

	insinto /usr/share/fcitx/addon
	doins unix/fcitx/fcitx-mozc.conf

	insinto /usr/share/fcitx/inputmethod
	doins unix/fcitx/mozc.conf

	insinto /usr/share/fcitx/mozc/icon
	newins data/images/product_icon_32bpp-128.png mozc.png
	local image
	for image in ../../${PN}/src/data/images/unix/ui-*.png; do
		newins "${image}" "mozc-${image#../../${PN}/src/data/images/unix/ui-}"
	done

	local locale mo_file
	for mo_file in out_linux/${BUILD_TYPE}/gen/unix/fcitx/po/*.mo; do
		locale="${mo_file##*/}"
		locale="${locale%.mo}"
		insinto /usr/share/locale/${locale}/LC_MESSAGES
		newins "${mo_file}" fcitx-mozc.mo
	done
	has_version app-i18n/mozc && { rm ${ED%/}/usr/libexec/mozc/{mozc_server,mozc_tool,documents/credits_en.html} || die ; }
}

pkg_postinst() {
	elog
	elog "ENVIRONMENTAL VARIABLES"
	elog
	elog "MOZC_SERVER_DIRECTORY"
	elog "  Mozc server directory"
	elog "  Value used by default: \"${EPREFIX}/usr/libexec/mozc\""
	elog "MOZC_DOCUMENTS_DIRECTORY"
	elog "  Mozc documents directory"
	elog "  Value used by default: \"${EPREFIX}/usr/libexec/mozc/documents\""
	elog "MOZC_CONFIGURATION_DIRECTORY"
	elog "  Mozc configuration directory"
	elog "  Value used by default: \"~/.mozc\""
	elog
	xdg_pkg_postinst
}
