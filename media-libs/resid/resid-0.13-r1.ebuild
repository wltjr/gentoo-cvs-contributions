# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/resid/resid-0.13-r1.ebuild,v 1.14 2007/05/20 07:37:01 opfer Exp $

DESCRIPTION="C++ library to emulate the C64 SID chip"
HOMEPAGE="http://sidplay2.sourceforge.net"
SRC_URI="mirror://sourceforge/sidplay2/${P}-p1.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ppc sparc x86"

src_install () {
	make DESTDIR=${D} install || die
}
