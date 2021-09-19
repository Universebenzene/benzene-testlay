# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ALSA Configuration for PulseAudio"
HOMEPAGE="http://www.pulseaudio.org"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=media-plugins/alsa-plugins-1.0.25
	media-sound/pulseaudio
"
BDEPEND=""

S=${WORKDIR}

src_install() {
	insinto /etc
	doins "${FILESDIR}"/*
}
