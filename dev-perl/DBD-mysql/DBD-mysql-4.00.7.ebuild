# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-mysql/DBD-mysql-4.00.7.ebuild,v 1.1 2008/07/30 00:47:51 robbat2 Exp $

inherit versionator

MODULE_AUTHOR="CAPTTOFU"
MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"

inherit eutils perl-module

S=${WORKDIR}/${MY_P}

DESCRIPTION="The Perl DBD:mysql Module"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/"
SRC_URI="mirror://cpan/authors/id/C/CA/CAPTTOFU/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/DBI
	virtual/mysql"

mydoc="ToDo"
