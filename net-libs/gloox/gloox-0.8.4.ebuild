# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gloox/gloox-0.8.4.ebuild,v 1.1 2007/10/22 21:43:59 jokey Exp $

DESCRIPTION="A portable high-level Jabber/XMPP library for C++"
HOMEPAGE="http://camaya.net/gloox"
SRC_URI="http://camaya.net/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gnutls idn ssl zlib"

DEPEND="idn? ( >=net-dns/libidn-0.5.0 )
	gnutls? ( >=net-libs/gnutls-1.2.0 )
	ssl? ( >=dev-libs/openssl-0.9.7 )
	zlib? ( sys-libs/zlib )
	dev-libs/iksemel"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		$(use_enable debug debug) \
		$(use_with idn libidn) \
		$(use_with gnutls gnutls) \
		$(use_with ssl openssl) \
		$(use_with zlib zlib) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
