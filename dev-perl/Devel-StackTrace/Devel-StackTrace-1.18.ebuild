# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-StackTrace/Devel-StackTrace-1.18.ebuild,v 1.2 2008/07/15 18:08:08 armin76 Exp $

inherit perl-module

DESCRIPTION="Devel-StackTrace module for perl"
HOMEPAGE="http://search.perl.com/~drolsky/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~ppc sparc x86"
IUSE=""
SRC_TEST="do"

RDEPEND="dev-lang/perl"
DEPEND=">=dev-perl/module-build-0.28
	virtual/perl-File-Spec
	${RDEPEND}"

OPTIMIZE="$CFLAGS"
