# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/digest-md2/digest-md2-2.03.ebuild,v 1.12 2006/08/06 02:18:39 mcummings Exp $

inherit perl-module

MY_P=Digest-MD2-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface to the MD2 Algorithm"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
