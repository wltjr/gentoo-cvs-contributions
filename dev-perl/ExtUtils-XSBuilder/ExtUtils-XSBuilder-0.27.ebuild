# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-XSBuilder/ExtUtils-XSBuilder-0.27.ebuild,v 1.1 2005/04/25 15:09:54 mcummings Exp $

inherit perl-module

DESCRIPTION="Modules to parse C header files and create XS glue code."
SRC_URI="mirror://cpan/authors/id/G/GR/GRICHTER/${P}.tar.gz"
HOMEPAGE="http://cpan.org/CPAN/authors/id/G/GR/GRICHTER/${P}.readme"
IUSE=""
SLOT="0"
SRC_TEST="do"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
DEPEND="dev-perl/Parse-RecDescent
		dev-perl/Tie-IxHash"
