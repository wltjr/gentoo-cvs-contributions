# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/libinklevel/libinklevel-0.6.ebuild,v 1.5 2004/07/05 16:15:37 centic Exp $

DESCRIPTION="A library to get the ink level of your printer"
SRC_URI="mirror:/sourceforge/libinklevel/${P}.tar.gz"
HOMEPAGE="http://libinklevel.sourceforge.net/"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"
IUSE=""

DEPEND="sys-libs/libieee1284"

S=${WORKDIR}/${PN}

src_install () {
	make DESTDIR=${D}/usr install || die
	dodoc COPYING README
}
