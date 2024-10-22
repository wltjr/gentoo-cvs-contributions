# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X11-FreeDesktop-DesktopEntry/X11-FreeDesktop-DesktopEntry-0.04.ebuild,v 1.10 2007/01/19 17:17:12 mcummings Exp $

inherit perl-module

DESCRIPTION="An interface to Freedesktop.org .desktop files."
HOMEPAGE="http://search.cpan.org/~gbrown/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBROWN/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl"
