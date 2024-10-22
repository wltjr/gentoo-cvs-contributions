# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML-Iterator/XML-LibXML-Iterator-1.04.ebuild,v 1.2 2008/07/18 18:29:56 armin76 Exp $

inherit perl-module

DESCRIPTION="No description available."
SRC_URI="mirror://cpan/authors/id/P/PH/PHISH/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~phish/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/XML-LibXML
	dev-perl/XML-NodeFilter
	dev-lang/perl"
