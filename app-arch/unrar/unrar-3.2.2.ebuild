# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar/unrar-3.2.2.ebuild,v 1.1 2003/06/24 22:02:17 mholzer Exp $

inherit eutils

MY_P=${PN}src
S=${WORKDIR}/${PN}
DESCRIPTION="Uncompress rar files"
SRC_URI="http://www.rarlab.com/rar/${MY_P}-${PV}.tar.gz
	mirror://gentoo/${PN}-gcc3.patch"
HOMEPAGE="http://www.rarlab.com/rar_add.htm"

SLOT="0"
LICENSE="unRAR"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND=""

src_compile() {
	epatch ${DISTDIR}/${PN}-gcc3.patch
	make -f makefile.unix || die
}

src_install() {
	dobin unrar
	dodoc readme.txt license.txt
}
