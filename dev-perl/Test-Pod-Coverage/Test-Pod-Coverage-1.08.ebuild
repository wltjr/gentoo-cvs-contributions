# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Pod-Coverage/Test-Pod-Coverage-1.08.ebuild,v 1.19 2008/06/06 09:07:34 aballier Exp $

inherit perl-module

DESCRIPTION="Check for pod coverage in your distribution"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~petdance/"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"

DEPEND=">=virtual/perl-Test-Simple-0.62
	dev-perl/Pod-Coverage
	dev-lang/perl"
