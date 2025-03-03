# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cpl-stratego/cpl-stratego-0.4.ebuild,v 1.16 2005/05/16 21:54:49 gustavoz Exp $

DESCRIPTION="Choice library mostly used by Stratego"
SRC_URI="ftp://ftp.stratego-language.org/pub/stratego/stratego/${P}.tar.gz"
HOMEPAGE="http://www.stratego-language.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc alpha ia64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README*
}
