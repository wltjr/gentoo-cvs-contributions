# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsmtp/libsmtp-0.8.ebuild,v 1.5 2007/09/20 18:13:41 armin76 Exp $

inherit eutils

DESCRIPTION="A small C library that allows direct SMTP connections conforming to RFC 822"
HOMEPAGE="http://libsmtp.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"

DEPEND="=dev-libs/glib-1*"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_install() {
	insinto /usr/include
	doins include/*.h
	dolib.a {smtp,mime}/*.a
	dodoc AUTHORS CHANGES INSTALL README doc/API doc/BUGS doc/MIME doc/TODO \
		|| die "dodoc failed"

	if use doc ; then
		cd ${S}/examples
		rm -fr CVS
		make clean
		docinto examples
		dodoc *
	fi
}
