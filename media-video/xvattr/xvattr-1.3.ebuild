# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvattr/xvattr-1.3.ebuild,v 1.1 2003/04/24 07:40:37 utx Exp $

DESCRIPTION="X11 XVideo Querying/Setting Tool from Ogle project"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${P}.tar.gz"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"
SLOT=0
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
DEPEND="x11-base/xfree
	=x11-libs/gtk+-1*"
RDEPEND="x11-base/xfree
	=x11-libs/gtk+-1*"

src_install() {
	make DESTDIR=${D} install
}
