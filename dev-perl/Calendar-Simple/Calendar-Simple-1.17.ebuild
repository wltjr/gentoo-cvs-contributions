# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Calendar-Simple/Calendar-Simple-1.17.ebuild,v 1.4 2007/12/27 14:05:30 ticho Exp $

inherit perl-module

DESCRIPTION="Perl extension to create simple calendars"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/D/DA/DAVECROSS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="test"

SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
		test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )
		dev-lang/perl"
RDEPEND="dev-lang/perl"
