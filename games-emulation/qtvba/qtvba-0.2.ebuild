# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/qtvba/qtvba-0.2.ebuild,v 1.1 2004/05/01 21:04:40 dholm Exp $

inherit eutils
inherit kde-functions
need-qt 3

DESCRIPTION="VisualBoyAdvance Frontend"
SRC_URI="http://www.apex.net.au/~twalker/qtvba/${P}.tar.gz"
HOMEPAGE="http://www.apex.net.au/~twalker/qtvba/"
LICENSE="GPL-2"
DEPEND="x11-libs/qt"
RDEPEND=">=games-emulation/visualboyadvance-1.5.1"
IUSE=""
SLOT="0"
KEYWORDS="~ppc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-Makefilefix.patch
}

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README
}
