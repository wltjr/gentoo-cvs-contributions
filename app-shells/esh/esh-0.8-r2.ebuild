# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-shells/esh/esh-0.8-r2.ebuild,v 1.2 2001/04/28 12:48:27 achim Exp $

P=esh-0.8      
A=${P}.tar.gz
S=${WORKDIR}/esh
DESCRIPTION="A UNIX Shell with a simplified Scheme syntax"
SRC_URI="http://esh.netpedia.net/"${A}
HOMEPAGE="http://esh.netpedia.net/"

DEPEND="virtual/glibc
        >=sys-libs/ncurses-5.1
        >=sys-libs/readline-4.1"

src_compile() {

	cp Makefile Makefile.orig
	sed -e "s:^CFLAGS=:CFLAGS=${CFLAGS} :" \
	    -e "s:^LIB=:LIB=-lncurses :" Makefile.orig > Makefile
	try make
}

src_install() {

	dobin esh
	into /usr
	doinfo doc/esh.info
	dodoc CHANGELOG CREDITS GC_README HEADER LICENSE READLNE-HACKS TODO
	docinto html
	dodoc doc/*.html
	docinto examples
	dodoc examples/*
	insinto /usr/share/emacs/site-lisp/
	doins emacs/esh-mode.el
}





