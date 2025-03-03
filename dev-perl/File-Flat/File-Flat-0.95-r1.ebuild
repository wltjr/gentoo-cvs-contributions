# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Flat/File-Flat-0.95-r1.ebuild,v 1.17 2007/01/15 19:06:33 mcummings Exp $

inherit perl-module

DESCRIPTION="Implements a flat filesystem"
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~adamk/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/Class-Autouse-1
	>=dev-perl/module-build-0.28
	dev-perl/File-Remove
	virtual/perl-File-Spec
	>=virtual/perl-File-Temp-0.14
	dev-perl/File-NCopy
	>=dev-perl/File-Remove-0.21
	dev-perl/Test-ClassAPI
	dev-perl/File-Slurp
	dev-perl/prefork
	dev-perl/Class-Inspector
	dev-lang/perl"
