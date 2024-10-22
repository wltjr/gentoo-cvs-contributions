# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/dircproxy/dircproxy-1.1.0-r2.ebuild,v 1.1 2007/10/15 13:25:14 armin76 Exp $

inherit eutils

DESCRIPTION="an IRC proxy server"
HOMEPAGE="http://dircproxy.securiweb.net/"
SRC_URI="http://dircproxy-securiweb.net/pub/1.1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${PV}-less-lag-on-attach.patch"
	epatch "${FILESDIR}/${PN}-gcc4.patch"
	epatch "${FILESDIR}/1.0.5-CVE-2007-5226.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog FAQ NEWS PROTOCOL README* INSTALL
}
