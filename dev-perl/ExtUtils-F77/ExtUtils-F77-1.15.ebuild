# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-F77/ExtUtils-F77-1.15.ebuild,v 1.12 2007/07/10 23:33:28 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Facilitate use of FORTRAN from Perl/XS code"
HOMEPAGE="http://search.cpan.org/~kgb/"
SRC_URI="mirror://cpan/authors/id/K/KG/KGB/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
