# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdirstat/kdirstat-2.4.0.ebuild,v 1.4 2005/04/24 03:18:20 hansmi Exp $

inherit kde eutils

DESCRIPTION="KDirStat - nice KDE replacement to du command"
HOMEPAGE="http://kdirstat.sourceforge.net/"
SRC_URI="mirror://sourceforge/kdirstat/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc ~amd64 ppc"

IUSE=""
SLOT="0"

need-kde 3

src_unpack() {
	unpack ${A}
	cd ${S}/kdirstat/
	epatch ${FILESDIR}/kdirstatapp.h.fix.patch
	cd ${S}
	! useq arts && epatch ${FILESDIR}/kdirstat-2.4.0-configure.patch
}
