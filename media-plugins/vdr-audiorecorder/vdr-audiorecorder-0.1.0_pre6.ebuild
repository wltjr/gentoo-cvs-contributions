# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-audiorecorder/vdr-audiorecorder-0.1.0_pre6.ebuild,v 1.5 2008/04/21 10:56:40 zzam Exp $

inherit vdr-plugin

MY_P=${P/_pre/-pre}

DESCRIPTION="VDR plugin: automatically record radio-channels and split it into tracks according to RadioText-Info"
HOMEPAGE="http://www.a-land.de/audiorecorder/"
SRC_URI="http://www.a-land.de/audiorecorder/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${MY_P#vdr-}

DEPEND=">=media-video/vdr-1.3.31
		media-libs/taglib
		>=media-video/ffmpeg-0.4.9
		"

RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${P}-vdr-1.5.0.diff")

src_unpack() {
	vdr-plugin_src_unpack

	if has_version ">=media-video/ffmpeg-0.4.9_p20080326"; then
		epatch "${FILESDIR}/${P}-ffmpeg-0.4.9_p20080326-new_header.diff"
	fi
}

src_install() {
	vdr-plugin_src_install
	keepdir /var/vdr/audiorecorder
	chown -R vdr:vdr "${D}"/var/vdr
}
