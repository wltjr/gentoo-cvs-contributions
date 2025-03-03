# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/bignum/bignum-0.19.ebuild,v 1.7 2007/06/24 23:20:37 vapier Exp $

inherit perl-module

DESCRIPTION="Transparent BigNumber/BigRational support for Perl"
HOMEPAGE="http://search.cpan.org/~tels"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/math/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

SRC_TEST="do"
PREFER_BUILDPL="no"

DEPEND=">=perl-core/Math-BigInt-1.79
	>=perl-core/Math-BigRat-0.17
	dev-lang/perl"
