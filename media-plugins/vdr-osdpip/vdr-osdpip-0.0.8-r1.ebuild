# Copyright 2003-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-osdpip/vdr-osdpip-0.0.8-r1.ebuild,v 1.5 2008/05/06 20:47:13 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: Show another channel in the OSD"
HOMEPAGE="http://www.magoa.net/linux"
SRC_URI="http://www.magoa.net/linux/files/${P}.tgz"

KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.7
	>=media-libs/libmpeg2-0.4.0
	>=media-video/ffmpeg-0.4.8
	"

PATCHES=("${FILESDIR}/${P}-includes.diff"
	"${FILESDIR}/${P}-gcc4.diff")

src_unpack() {
	vdr-plugin_src_unpack

	sed -i Makefile \
	  -e 's+^FFMDIR.*$+FFMDIR = /usr/include/ffmpeg+' \
	  -e 's+-I\$(FFMDIR)/libavcodec+-I$(FFMDIR)+' \
	  -e 's+-L\$(FFMDIR)/libavcodec++'
}
