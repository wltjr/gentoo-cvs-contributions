# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgpio/libgpio-20020507.ebuild,v 1.6 2002/12/09 04:26:12 manson Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="I/O library for GPhoto 2.x"
SRC_URI="http://www.ibiblio.org/gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.gphoto.org"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc "

DEPEND="dev-libs/libusb 
	sys-devel/automake 
	sys-devel/autoconf 
	sys-devel/libtool"

RDEPEND="dev-libs/libusb"

src_compile() {

	./autogen.sh --prefix=/usr --host=${CHOST} || die
	make || die

}

src_install () {

	make DESTDIR=${D} install || die

}
