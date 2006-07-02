# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Valid/Email-Valid-0.15-r1.ebuild,v 1.5 2006/07/02 10:05:05 ian Exp $

inherit perl-module

DESCRIPTION="Check validity of Internet email addresses."
SRC_URI="mirror://cpan/authors/id/M/MA/MAURICE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~maurice/${P}/"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
LICENSE="|| ( GPL-2 Artistic )"
IUSE=""
SRC_TEST="do"
DEPEND="dev-perl/MailTools
	dev-perl/Net-Domain-TLD
	dev-perl/Net-DNS"
