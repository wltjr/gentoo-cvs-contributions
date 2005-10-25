# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gcolor/gcolor-0.4.ebuild,v 1.9 2005/10/25 11:52:32 nelchael Exp $

DESCRIPTION="A simple color selector."
HOMEPAGE="http://gcolor.sourceforge.net/"
LICENSE="GPL-2"
DEPEND="=x11-libs/gtk+-1*"

SLOT="0"
KEYWORDS="x86 ppc ppc64 amd64"
IUSE=""

SRC_URI="mirror://sourceforge/gcolor/${P}.tar.gz"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ABOUT-NLS INSTALL README AUTHORS COPYING NEWS ChangeLog
}
