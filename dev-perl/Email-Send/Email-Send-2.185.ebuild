# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Send/Email-Send-2.185.ebuild,v 1.8 2007/07/10 23:33:26 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Simply Sending Email"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc ~x86"

DEPEND="virtual/perl-Test-Simple
	>=dev-perl/Module-Pluggable-2.97
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Return-Value-1.302
	virtual/perl-File-Spec
	dev-perl/Email-Simple
	dev-perl/Email-Address
	dev-lang/perl"

SRC_TEST="do"
