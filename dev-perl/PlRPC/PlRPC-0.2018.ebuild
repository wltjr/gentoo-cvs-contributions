# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PlRPC/PlRPC-0.2018.ebuild,v 1.15 2007/01/19 15:26:35 mcummings Exp $

inherit perl-module

DESCRIPTION="The Perl RPC Module"
SRC_URI="mirror://cpan/authors/id/J/JW/JWIED/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jwied/"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/perl-Storable-1.0.7
	>=dev-perl/Net-Daemon-0.34
	dev-lang/perl"
