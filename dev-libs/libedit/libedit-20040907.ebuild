# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libedit/libedit-20040907.ebuild,v 1.3 2004/09/25 07:26:28 vapier Exp $

inherit eutils

DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libedit/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="arm hppa ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses
	virtual/libc"

S=${WORKDIR}/netbsd-cvs

src_unpack() {
	unpack ${A}
	cd ${S}
	mv ${WORKDIR}/glibc-*/*.c .
	epatch ${FILESDIR}/20031222-debian-to-gentoo.patch
}

src_compile() {
	emake -j1 .depend || die "depend"
	emake || die "make"
}

src_install() {
	dolib.so libedit.so || die "dolib.so"
	dolib.a libedit.a || die "dolib.a"
	doman *.[35]
}
