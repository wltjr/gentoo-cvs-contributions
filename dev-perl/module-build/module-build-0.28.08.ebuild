# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/module-build/module-build-0.28.08.ebuild,v 1.10 2008/03/28 09:30:15 jer Exp $

inherit versionator perl-module

MY_PV="$(delete_version_separator 2)"
MY_P="Module-Build-${MY_PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Build and install Perl modules"
HOMEPAGE="http://search.cpan.org/~kwilliams/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 m68k mips ppc ppc64 sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="test"

# Removing these as hard deps. They are listed as recommended in the Build.PL,
# but end up causing a dep loop since they require module-build to be built.
# ~mcummings 06.16.06
PDEPEND=">=dev-perl/ExtUtils-CBuilder-0.15
	>=dev-perl/extutils-parsexs-1.02"

DEPEND="dev-lang/perl
	dev-perl/yaml
	test? ( dev-perl/version )
	>=dev-perl/Archive-Tar-1.09"

SRC_TEST="do"
