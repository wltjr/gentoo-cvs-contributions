# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Escapes/Pod-Escapes-1.04.ebuild,v 1.21 2007/07/10 23:33:33 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="for resolving Pod E<...> sequences"
HOMEPAGE="http://search.cpan.org/~sburke/"
SRC_URI="mirror://cpan/authors/id/S/SB/SBURKE/${P}.tar.gz"

SRC_TEST="do"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
