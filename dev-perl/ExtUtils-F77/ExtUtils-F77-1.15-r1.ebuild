# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-F77/ExtUtils-F77-1.15-r1.ebuild,v 1.1 2007/04/16 16:39:43 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Facilitate use of FORTRAN from Perl/XS code"
HOMEPAGE="http://search.cpan.org/~kgb/"
SRC_URI="mirror://cpan/authors/id/K/KG/KGB/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	has_version '>sys-devel/gcc-4.0.9999' && epatch ${FILESDIR}/perl-ExtUtils-F77-1.15-alt-g77.patch
}
