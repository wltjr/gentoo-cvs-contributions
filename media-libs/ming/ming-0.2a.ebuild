# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ming/ming-0.2a.ebuild,v 1.5 2002/12/09 04:26:13 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A OpenSource library from flash movie generation"
SRC_URI="http://www.opaque.net/ming/${PN}-${PV}.tgz"
HOMEPAGE="http://www.opaque.net/ming/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}/util
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff || die
}

src_compile() {

	make all static || die
	cd util 
	make bindump hexdump listswf listfdb listmp3 listjpeg makefdb swftophp \
		|| die
}

src_install () { 
	dolib.so libming.so
	dolib.a  libming.a
	insinto /usr/include
	doins ming.h
	exeinto /usr/lib/ming
	doexe util/{bindump,hexdump,listswf,listfdb,listmp3,listjpeg,makefdb,swftophp}
	dodoc CHANGES CREDITS LICENSE README TODO
	newdoc util/README README.util
	newdoc util/TODO TODO.util
}
