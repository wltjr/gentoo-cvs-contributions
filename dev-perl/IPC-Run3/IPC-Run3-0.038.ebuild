# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IPC-Run3/IPC-Run3-0.038.ebuild,v 1.7 2008/07/17 20:50:46 armin76 Exp $

inherit perl-module

DESCRIPTION="Run a subprocess in batch mode (a la system)"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?module=${PN}"
IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc sparc x86"

SRC_TEST="do"

DEPEND=">=dev-perl/Test-Pod-1.00
	>=dev-perl/Test-Pod-Coverage-1.04
	dev-lang/perl"
