# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tk-CursorControl/Tk-CursorControl-0.4.ebuild,v 1.10 2007/01/19 17:04:14 mcummings Exp $

inherit perl-module

DESCRIPTION="Manipulate the mouse cursor programmatically"
HOMEPAGE="http://search.cpan.org/~dunniganj/"
SRC_URI="mirror://cpan/authors/id/D/DU/DUNNIGANJ/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE=""

#SRC_TEST="do"

DEPEND="dev-perl/perl-tk
	dev-lang/perl"
