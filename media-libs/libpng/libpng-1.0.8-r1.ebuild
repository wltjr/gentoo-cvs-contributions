# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpng/libpng-1.0.8-r1.ebuild,v 1.3 2000/09/15 20:09:02 drobbins Exp $

P=libpng-1.0.8
A="${P}.tar.gz"
S=${WORKDIR}/${P}
DESCRIPTION="libpng"
SRC_URI="http://www.libpng.org/pub/png/src/${P}.tar.gz"
HOMEPAGE="http://www.libpng.org/"

src_unpack() {
  unpack ${P}.tar.gz
  cd ${S}
}

src_compile() {
  cd ${S}
  sed -e "s:ZLIBLIB=../zlib:ZLIBLIB=/usr/lib:" \
	-e "s:ZLIBINC=../zlib:ZLIBINC=/usr/include:" \
	-e "s:prefix=/usr:prefix=${D}/usr:" \
	-e "s/-O3/${CFLAGS}/" \
	 scripts/makefile.linux > Makefile
  try make
}


src_install() {                 
	cd ${S}
	mkdir ${D}/usr
	mkdir ${D}/usr/include
	mkdir ${D}/usr/lib
	try make install prefix=${D}/usr
	into /usr
 	doman *.3 *.5
	dodoc ANNOUNCE CHANGES KNOWNBUG LICENSE README TODO Y2KINFO 
}
