# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/nasm/nasm-0.98.31.ebuild,v 1.12 2003/03/25 18:00:44 carpaski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="groovy little assembler"
SRC_URI="mirror://sourceforge/nasm/${P}.tar.bz2"
HOMEPAGE="http://nasm.sourceforge.net/"

DEPEND="virtual/glibc sys-apps/texinfo !build? ( dev-lang/perl )"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 -ppc -sparc "

src_compile() {			   
	./configure --prefix=/usr || die

	if [ "`use build`" ]; then
		make nasm
	else
		make || die
		cd doc
		make || die
	fi
}

src_install() {
	if [ "`use build`" ]; then
		dobin nasm
	else
		dobin nasm ndisasm
		dobin rdoff/ldrdf rdoff/rdf2bin rdoff/rdfdump rdoff/rdflib rdoff/rdx
		doman nasm.1 ndisasm.1
		dodoc COPYING Changes Licence MODIFIED Readme Wishlist
		docinto txt
		cd doc
		dodoc nasmdoc.txt
		dohtml html/*.html
		docinto ps
		dodoc nasmdoc.ps
		docinto rtf
		dodoc nasmdoc.rtf

		doinfo info/*.info*
	fi
}
