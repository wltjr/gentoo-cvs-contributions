# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-1.11.23.ebuild,v 1.1 2002/05/21 09:26:42 agenkin Exp $

DESCRIPTION="cdrtools - A set of tools for CDR drives, including cdrecord"
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html"

DEPEND="virtual/glibc"
SLOT="0"

SRC_URI="ftp://ftp.fokus.gmd.de:21/pub/unix/cdrecord/alpha/${PN}-1.11a23.tar.bz2"
S=${WORKDIR}/${PN}-1.11

src_unpack() {
	unpack ${A}
	cd ${S}/DEFAULTS
	cp Defaults.linux Defaults.linux.bak
	sed -e "s:/opt/schily:/usr:g" Defaults.linux.bak > Defaults.linux
	cd ..
}

src_compile() {
	emake || die
}

src_install() {
	dobin cdda2wav/OBJ/*-linux-cc/cdda2wav
	dobin cdrecord/OBJ/*-linux-cc/cdrecord
	cd ${S}
	dobin mkisofs/OBJ/*-linux-cc/mkisofs
	dobin readcd/OBJ/*-linux-cc/readcd
	insinto /usr/include
	doins incs/*-linux-cc/align.h incs/*-linux-cc/avoffset.h

	cd mkisofs/diag/OBJ/*-linux-cc
	dobin devdump isodump isoinfo isovfy

	cd ${S}/libs/*-linux-cc
	dolib.a *.a

	cd  ${S}
	dodoc Changelog COPYING PORTING README* START

	cd ${S}/doc
	dodoc cdrecord-1.8.1_de-doc_0.1.tar
	docinto print
	dodoc *.ps
	newman cdda2wav.man cdda2wav.1
	newman cdrecord.man cdrecord.1
	newman readcd.man readcd.1
	newman isoinfo.man isoinfo.8
	newman mkisofs.man mkisofs.8
}
