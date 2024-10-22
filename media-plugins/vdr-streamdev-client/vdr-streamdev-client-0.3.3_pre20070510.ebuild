# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-streamdev-client/vdr-streamdev-client-0.3.3_pre20070510.ebuild,v 1.3 2008/06/18 16:29:30 zzam Exp $

inherit vdr-plugin eutils

VDRPLUGIN_BASE=${VDRPLUGIN//-*/}
MY_P=${VDRPLUGIN_BASE}-${PV/*_pre/}

DESCRIPTION="Video Disk Recorder Client/Server streaming plugin"
HOMEPAGE="http://www.magoa.net/linux/"
SRC_URI="mirror://gentoo/vdr-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.24
	!media-plugins/vdr-streamdev"

S=${WORKDIR}/${MY_P}

VDRPLUGIN_MAKE_TARGET="libvdr-${VDRPLUGIN}.so"

src_unpack() {
	vdr-plugin_src_unpack
	cd "${S}"

	# make subdir libdvbmpeg respect CXXFLAGS
	sed -i Makefile \
		-e 's:\(CXXFLAGS.*=\):#\1:'
	sed -i libdvbmpeg/Makefile \
		-e 's:CFLAGS =  -g -Wall -O2:CFLAGS = $(CXXFLAGS) :'
}
