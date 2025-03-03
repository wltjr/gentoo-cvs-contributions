# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvd/vdr-dvd-0.3.7_pre20071113-r1.ebuild,v 1.2 2008/04/28 10:56:59 zzam Exp $

inherit vdr-plugin

MY_P="${PN}-cvs-${PV#*_pre}"
S="${WORKDIR}/${MY_P#vdr-}"

DESCRIPTION="VDR Plugin: DVD-Player"
HOMEPAGE="http://sourceforge.net/projects/dvdplugin"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	http://dev.gentoo.org/~zzam/distfiles/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.34
		>=media-libs/libdvdcss-1.2.8
		>=media-libs/libdvdnav-0.1.9
		>=media-libs/libdvdread-0.9.4
		>=media-libs/a52dec-0.7.4"

RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/dvd-a52drc-pre20071113.diff
		${FILESDIR}/dvdspeed-cvs-20071113-2.diff
		${FILESDIR}/gcc-4.x-compilefix.diff"
