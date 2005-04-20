# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WeakRef/WeakRef-0.01.ebuild,v 1.5 2005/04/20 21:40:01 hansmi Exp $

inherit perl-module

CATEGORY="dev-perl"

DESCRIPTION="an API to the Perl weak references"

HOMEPAGE="http://search.cpan.org/~lukka/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/L/LU/LUKKA/${P}.tar.gz"
SRC_TEST="do"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~amd64 ppc ~sparc ~alpha"
IUSE=""
