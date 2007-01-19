# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Snowball-Norwegian/Snowball-Norwegian-1.0.ebuild,v 1.10 2007/01/19 15:45:42 mcummings Exp $

inherit perl-module

DESCRIPTION="Porters stemming algorithm for Norwegian"
HOMEPAGE="http://search.cpan.org/~asksh/"
SRC_URI="mirror://cpan/authors/id/A/AS/ASKSH/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
