# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-NoWarnings/Test-NoWarnings-0.084.ebuild,v 1.2 2008/07/17 20:55:02 armin76 Exp $

inherit perl-module
IUSE=""

DESCRIPTION="Make sure you didn't emit any warnings while testing"
SRC_URI="mirror://cpan/authors/id/F/FD/FDALY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~fdaly/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 ia64 ~ppc sparc x86"

SRC_TEST="do"

DEPEND="dev-perl/Test-Tester
	dev-lang/perl"
