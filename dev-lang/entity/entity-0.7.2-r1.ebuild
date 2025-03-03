# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/entity/entity-0.7.2-r1.ebuild,v 1.19 2007/07/13 06:25:50 mr_bones_ Exp $

IUSE="sdl ssl opengl python tk perl"

DESCRIPTION="An XML Framework"
SRC_URI="http://www.entity.cx/Download/files/${P}.tar.gz"
HOMEPAGE="http://www.entity.cx/"

DEPEND=">=media-libs/imlib-1.9.10-r1
	>=dev-libs/libpcre-3.2
	tk? ( >=dev-lang/tk-8.1.1 )
	perl? ( >=dev-lang/perl-5.6 )
	python? ( >=dev-lang/python-2.0-r4 )
	sdl? ( >=media-libs/libsdl-1.1.7 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	opengl? ( <x11-libs/gtkglarea-1.99.0 )"

SLOT="0"
LICENSE="MIT"
KEYWORDS="x86 sparc"

src_compile() {

	local myconf
	use tk \
		&& myconf="--enable-tcl=module --with-tcl=/usr/lib" \
		|| myconf="--enable-tcl=no"

	use perl \
		&& myconf="${myconf} --enable-perl=static" \
		|| myconf="${myconf} --enable-perl=no"

	use python \
		&& myconf="${myconf} --enable-python=static" \
		|| myconf="${myconf} --enable-python=no"

	use ssl \
		&& myconf="${myconf} --enable-openssl"

	use sdl \
		&& myconf="${myconf} --enable-sdl"

	use opengl \
		&& myconf="${myconf} --enable-gtkgl"

	DEBIAN_ENTITY_MAGIC="voodoo" CFLAGS="$CFLAGS -I/usr/X11R6/include" \
		econf \
			--enable-exec-class=yes \
			--enable-gtk=module \
			--enable-c=module \
			--enable-javascript=yes \
			--with-included-njs \
			--enable-csinc \
			${myconf} || die

	make \
	LDFLAGS="-L/usr/lib/python2.0/config/ -lpython2.0 `python-config --libs`" \
		|| die
}

src_install () {
	make DESTDIR=${D} LD_LIBRARY_PATH=${D}/usr/lib install || die

	insinto /usr/share/entity/stembuilder
	doins stembuilder/*.e
	chmod +x ${D}/usr/share/entity/stembuilder/stembuilder.e
	insinto /usr/share/entity/apps
	doins apps/*.e
	chmod +x ${D}/usr/share/entity/apps/{enview,ev}.e
	exeinto /usr/share/entity/examples
	doexe examples/*.e
	insinto /usr/share/entity/stembuilder/images
	doins stembuilder/images/*.xpm

	dodoc AUTHORS COPYING ChangeLog LICENSE NEWS README TODO
	docinto txt
	dodoc docs/README* docs/*.txt docs/*.ascii
	dohtml -r docs
	docinto print
	dodoc docs/*.ps
	docinto sgml
	dodoc docs/*.sgml
}
