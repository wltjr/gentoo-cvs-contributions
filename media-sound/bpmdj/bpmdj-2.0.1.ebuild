# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bpmdj/bpmdj-2.0.1.ebuild,v 1.1 2003/09/29 02:21:13 jje Exp $

inherit eutils
S=${WORKDIR}/bpmdj-2.0

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.strokemusic.org"
SRC_URI="ftp://progpc26.vub.ac.be/pub/bpmdj/2.0/bpmdj-2.0.source.tgz
	ftp://progpc26.vub.ac.be/pub/bpmdj/2.0/patch-2.0-to-2.0.1.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="x11-libs/qt*
	virtual/tetex"

RDEPEND="mpg123"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/patch-2.0-to-2.0.1
	epatch ${FILESDIR}/gcc.patch
}


src_compile() {
	cp defines.gentoo defines
	make ${MAKEOPTS} CPP=g++ CC=gcc VARTEXFONTS=${T}/fonts || die
}

src_install () {
	make DESTDIR=${D} deb-install || die
	mv ${D}/usr/share/doc/{${PN},${PF}}
}

