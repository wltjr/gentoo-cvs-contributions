# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/vnc2swf/vnc2swf-0.3.ebuild,v 1.6 2004/06/28 20:27:12 agriffis Exp $

SLOT="0"
DESCRIPTION="A tool for recording Shock wave Flash movies from vnc sessions"
SRC_URI="http://www.unixuser.org/~euske/vnc2swf/${P}.tar.gz"
HOMEPAGE="http://www.unixuser.org/~euske/vnc2swf"
LICENSE="GPL-2"
DEPEND=">=media-libs/ming-0.2a
		virtual/libc
		virtual/x11"
KEYWORDS="x86 ~ppc"
IUSE=""

src_compile() {
	econf || die "Configure Failed"
	emake || die "Make Failed"
}

src_install () {
	insinto /usr/bin
	dobin vnc2swf || die "Install Failed"
	dodoc README TODO
}
