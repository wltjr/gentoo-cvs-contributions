# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Inline-Python/Inline-Python-0.22.ebuild,v 1.1 2006/11/25 14:27:13 mcummings Exp $

inherit perl-module

DESCRIPTION="Easy implimentaiton of Java extensions"
HOMEPAGE="http://search.cpan.org/~neilw/"
SRC_URI="mirror://cpan/authors/id/N/NE/NEILW/${P}.tar.gz"

LICENSE="Artistic"
#LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/Inline-0.42
	dev-lang/python
	dev-lang/perl"


