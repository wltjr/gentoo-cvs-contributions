# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/File-Spec/File-Spec-3.15.ebuild,v 1.13 2007/01/19 17:58:08 mcummings Exp $

inherit perl-module

MY_P="PathTools-${PV}"
S=${WORKDIR}/${MY_P}

myconf='INSTALLDIRS=vendor'

DESCRIPTION="Handling files and directories portably"
HOMEPAGE="http://search.cpan.org/~kwilliams/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ~ppc64 s390 sh sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
		dev-perl/module-build
		dev-perl/ExtUtils-CBuilder"
