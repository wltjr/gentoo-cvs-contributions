# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Audit/Mail-Audit-2.214.ebuild,v 1.4 2007/05/05 17:56:47 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Mail sorting/delivery module for Perl."
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/${P}.readme"

LICENSE="Artistic"
#KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc ~x86"
IUSE=""

SLOT="0"
DEPEND="dev-perl/MIME-tools
	>=dev-perl/Mail-POP3Client-2.7
	>=dev-perl/MailTools-1.15
	dev-perl/Mail-ListDetector
	dev-lang/perl"
