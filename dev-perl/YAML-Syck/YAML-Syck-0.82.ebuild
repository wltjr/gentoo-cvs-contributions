# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/YAML-Syck/YAML-Syck-0.82.ebuild,v 1.3 2007/04/22 14:05:49 mcummings Exp $

inherit perl-module

DESCRIPTION="Fast, lightweight YAML loader and dumper"
HOMEPAGE="http://search.cpan.org/~audreyt/"
SRC_URI="mirror://cpan/authors/id/A/AU/AUDREYT/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="|| ( dev-libs/syck >=dev-lang/ruby-1.8 )
		dev-lang/perl"
