# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdv/libdv-0.99.ebuild,v 1.3 2003/07/18 21:55:44 tester Exp $

IUSE="sdl gtk xv"

S=${WORKDIR}/${P}
DESCRIPTION="software codec for dv-format video (camcorders etc)"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libdv.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha amd64"

DEPEND=" dev-libs/popt
	gtk? ( =x11-libs/gtk+-1.2* )
	gtk? ( =dev-libs/glib-1.2* )
	xv? ( x11-base/xfree )
	dev-util/pkgconfig
	sdl? ( >=media-libs/libsdl-1.2.4.20020601 )"
	
src_compile() {
	myconf="--without-debug"
	
	use gtk \
		|| myconf="$myconf --disable-gtk"
	use sdl \
		&& myconf="$myconf --enable-sdl" \
		|| myconf="$myconf --disable-sdl"
	use xv \
		|| myconf="$mycong --disable-xv"

	unset CFLAGS CXXFLAGS

	econf ${myconf} || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING COPYRIGHT ChangeLog INSTALL NEWS README* TODO
}
