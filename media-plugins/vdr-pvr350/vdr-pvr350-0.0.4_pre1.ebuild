# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pvr350/vdr-pvr350-0.0.4_pre1.ebuild,v 1.9 2008/07/01 19:56:23 zzam Exp $
inherit vdr-plugin eutils

IUSE="yaepg"

MY_P=${PN}-${PV/_/}

DESCRIPTION="VDR plugin: use a PVR350 as output device"
HOMEPAGE="http://www.rst38.org.uk/vdr/pvr350"
SRC_URI="http://www.rst38.org.uk/vdr/pvr350/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

S=${WORKDIR}/${MY_P#vdr-}

DEPEND=">=media-video/vdr-1.2.6
	>=media-tv/ivtv-0.1.9-r4"

pkg_setup() {
	vdr-plugin_pkg_setup

	if use yaepg; then
		elog "Checking for patched vdr"
		grep -q fontYaepg /usr/include/vdr/font.h
		eend $? "You need to emerge vdr with use-flag yaepg set!" || die "Unpatched vdr detected!"

		BUILD_PARAMS="SET_VIDEO_WINDOW=1"
	fi
}

src_unpack() {
	vdr-plugin_src_unpack

	sed -e 's/-I$(LIBAVCODEC)//' -i Makefile

	epatch "${FILESDIR}/${P}-vdr-1.3.42.diff"
}
