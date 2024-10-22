# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Locale/DateTime-Locale-0.32.ebuild,v 1.6 2007/04/15 21:27:20 corsair Exp $

inherit versionator perl-module

MY_P="${PN}-$(delete_version_separator 2)"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Localization support for DateTime"
HOMEPAGE="http://search.cpan.org/~drolsky/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
		${RDEPEND}"
RDEPEND="dev-perl/Params-Validate
	dev-lang/perl"
