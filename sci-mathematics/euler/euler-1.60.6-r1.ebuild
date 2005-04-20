# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/euler/euler-1.60.6-r1.ebuild,v 1.3 2005/04/20 21:40:24 hansmi Exp $

inherit eutils
IUSE=""

#euler only uses two major numners internally, need to do some mangling
MajVer="$(echo ${PV}|cut -d '.' -f 1,2)"
S=${WORKDIR}/${PN}-${MajVer}

DESCRIPTION="Mathematical programming environment"
HOMEPAGE="http://euler.sourceforge.net/"
SRC_URI="mirror://sourceforge/euler/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc -sparc amd64"

DEPEND="virtual/libc
	virtual/x11
	=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}/source
	epatch ${FILESDIR}/${P}.patch
	epatch ${FILESDIR}/euler-1.60-compound_statements.patch
	sed -e "s:share/euler/docs/index.html:share/doc/${P}/html/index.html:" \
		-i main.c
	sed -e "s:-O2:\$(CFLAGS):" -i makefile
}

src_compile() {
	cd ${S}/source
	emake INSTALL_DIR=/usr || die
}

src_install() {
	cd ${S}/source
	dodir usr usr/share usr/bin
	make INSTALL_DIR=${D}/usr install || die

	cd ${S}
	dodir usr/share/doc/${P}/html
	mv ${D}/usr/share/doc/${PN}/* ${D}/usr/share/doc/${PF}/html
	rm -rf ${D}/usr/share/doc/${PN}
	dodoc ChangeLog README TODO
}
