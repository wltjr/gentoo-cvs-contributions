# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Memoize/Memoize-1.00.ebuild,v 1.3 2002/07/25 04:43:33 seemant Exp $

inherit perl-module

MY_P=Memoize-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Generic Perl function result caching system"
SRC_URI="http://www.cpan.org/modules/by-module/Memoize/${MY_P}.tar.gz"
HOMEPAGE="http://perl.plover.com/Memoize/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86"

src_compile() {
	base_src_compile
	base_src_test || die "test failed"
}
