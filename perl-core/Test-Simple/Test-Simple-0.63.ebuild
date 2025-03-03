# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Test-Simple/Test-Simple-0.63.ebuild,v 1.4 2006/10/21 22:57:43 vapier Exp $

inherit perl-module

DESCRIPTION="Basic utilities for writing tests"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mschwern/${P}/"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc ~x86"

mydoc="rfc*.txt"
myconf="INSTALLDIRS=vendor"
DEPEND=">=dev-lang/perl-5.8.0-r12"

SRC_TEST="do"
