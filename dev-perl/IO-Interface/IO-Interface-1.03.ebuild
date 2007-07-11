# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Interface/IO-Interface-1.03.ebuild,v 1.6 2007/07/11 20:18:07 armin76 Exp $

inherit perl-module

DESCRIPTION="Perl extension for access to network card configuration information"
HOMEPAGE="http://search.cpan.org/dist/${P}/"
SRC_URI="mirror://cpan/authors/id/L/LD/LDS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha amd64 ia64 ppc sparc x86"

SRC_TEST="do"
