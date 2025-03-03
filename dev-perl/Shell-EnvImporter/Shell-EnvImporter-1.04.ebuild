# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Shell-EnvImporter/Shell-EnvImporter-1.04.ebuild,v 1.18 2008/07/02 18:11:39 the_paya Exp $

inherit perl-module

DESCRIPTION="Perl extension for importing environment variable changes from external commands or shell scripts"
HOMEPAGE="http://search.cpan.org/~dfaraldo"
SRC_URI="mirror://cpan/authors/id/D/DF/DFARALDO/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DEPEND=">=dev-perl/Class-MethodMaker-2
		dev-lang/perl"
