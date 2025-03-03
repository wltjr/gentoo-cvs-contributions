# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/libdbi/libdbi-0.8.1.ebuild,v 1.5 2007/06/20 07:43:03 opfer Exp $

DESCRIPTION="libdbi implements a database-independent abstraction layer in C, similar to the DBI/DBD layer in Perl."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libdbi.sourceforge.net/"
LICENSE="LGPL-2.1"
RDEPEND="virtual/libc"
DEPEND=">=sys-apps/sed-4
		${RDEPEND}"
PDEPEND=">=dev-db/libdbi-drivers-0.8.0"
IUSE=""
KEYWORDS="amd64 hppa ppc ~sparc x86"
SLOT=0

src_unpack() {
	unpack ${A}
	chown -R portage:portage ${S}
}

src_compile() {
	# should append CFLAGS, not replace them
	sed -i.orig -e 's/^CFLAGS = /CFLAGS += /g' src/Makefile.in
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake install DESTDIR=${D} || die "make install failed"
	dodoc AUTHORS ChangeLog COPYING README README.osx TODO
}
