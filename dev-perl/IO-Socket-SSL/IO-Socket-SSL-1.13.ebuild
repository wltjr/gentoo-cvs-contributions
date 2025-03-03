# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Socket-SSL/IO-Socket-SSL-1.13.ebuild,v 1.5 2008/07/15 20:30:27 armin76 Exp $

inherit perl-module

DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"
HOMEPAGE="http://search.cpan.org/~sullr/IO-Socket-SSL/"
SRC_URI="mirror://cpan/authors/id/S/SU/SULLR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~mips ~ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/Net-SSLeay-1.21
	dev-lang/perl"
