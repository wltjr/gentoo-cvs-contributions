# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt/rxvt-2.7.8-r4.ebuild,v 1.1 2002/06/17 20:13:36 naz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="rxvt -- nice small x11 terminal"
SRC_URI="ftp://ftp.rxvt.org/pub/rxvt/${P}.tar.gz"

HOMEPAGE=http://www.rxvt.org

DEPEND="virtual/glibc
	virtual/x11
	motif? ( x11-libs/openmotif )"


src_unpack() {

	unpack ${A}
	cd ${S}

	
	[ "`use motif`" ] && patch -p1 < ${FILESDIR}/rxvt-2.7.8-azz4.diff
}

src_compile() {
	./configure \
		--host=${CHOST}	\
		--prefix=/usr \
		--mandir=/usr/share/man	\
		--enable-rxvt-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-menubar \
		--enable-shared \
		--enable-keepscrolling || die

	emake || die
}

src_install() {

	make    \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
	install || die
	
	cd ${S}/doc
	dodoc README* *.txt BUGS FAQ
	dohtml *.html
}
