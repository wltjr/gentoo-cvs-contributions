# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Virtual/Class-Virtual-0.05.ebuild,v 1.10 2006/10/08 12:22:19 mcummings Exp $

inherit perl-module

DESCRIPTION="Base class for virtual base classes."
HOMEPAGE="http://search.cpan.org/~mschwern/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Class-Data-Inheritable
		dev-perl/Carp-Assert
	dev-lang/perl"
