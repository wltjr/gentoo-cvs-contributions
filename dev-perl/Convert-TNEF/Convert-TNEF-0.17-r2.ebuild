# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-TNEF/Convert-TNEF-0.17-r2.ebuild,v 1.17 2007/01/15 15:18:25 mcummings Exp $

inherit perl-module

DESCRIPTION="A Perl module for reading TNEF files"
SRC_URI="mirror://cpan/authors/id/D/DO/DOUGW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dougw/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-perl/MIME-tools
	dev-lang/perl"
