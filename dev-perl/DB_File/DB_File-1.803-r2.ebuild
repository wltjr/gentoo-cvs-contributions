# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DB_File/DB_File-1.803-r2.ebuild,v 1.13 2005/03/14 14:30:24 kugelfang Exp $

inherit perl-module

DESCRIPTION="A Berkeley DB Support Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/DB_File/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/DB_File/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc alpha sparc hppa ~mips ia64"
IUSE=""

DEPEND="${DEPEND}
	=sys-libs/db-3.2*"

mydoc="Changes"

src_compile() {

	cp ${FILESDIR}/config.in .
	cd ${S}
	cp Makefile.PL Makefile.PL.bak
	sed -e "s|' '|''|g" Makefile.PL.bak > Makefile.PL
	perl-module_src_compile

}
