# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.7 2002/08/14 13:08:09 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Font Library"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="ftp://ftp.enlightenment.org/pub/enlightenment/enlightenment/libs/${P}.tar.gz"

DEPEND="virtual/glibc
	>=media-libs/imlib-1.9.8.1"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {

	econf --sysconfdir=/etc/fnlib || die
	make || die
}

src_install() {
	
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog COPYING* HACKING NEWS README
	dodoc doc/fontinfo.README

}
