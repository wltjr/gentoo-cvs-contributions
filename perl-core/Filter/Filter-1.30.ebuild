# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Filter/Filter-1.30.ebuild,v 1.4 2006/08/04 13:25:19 mcummings Exp $

inherit perl-module

DESCRIPTION="Interface for creation of Perl Filters"
HOMEPAGE="http://search.cpan.org/~pmqs/${P}.readme"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc s390 sparc x86"
IUSE=""

mymake="/usr"

DEPEND="dev-lang/perl"
