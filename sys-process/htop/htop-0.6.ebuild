# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/htop/htop-0.6.ebuild,v 1.2 2006/03/31 01:30:55 flameeyes Exp $

inherit debug flag-o-matic

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://htop.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
DEPEND="sys-libs/ncurses"

src_compile() {
	useq debug && append-flags -O -ggdb -DDEBUG
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog TODO
}
