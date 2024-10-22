# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Checksums/CPAN-Checksums-1.039.ebuild,v 1.8 2007/01/15 15:26:32 mcummings Exp $

inherit perl-module

DESCRIPTION="Write a CHECKSUMS file for a directory as on CPAN"
HOMEPAGE="http://search.cpan.org/~andk/"
SRC_URI="mirror://cpan/authors/id/A/AN/ANDK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="ia64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Data-Compare
		dev-perl/Compress-Zlib
		dev-perl/Compress-Bzip2
		dev-perl/Digest-SHA
		virtual/perl-Digest-MD5
	dev-lang/perl"
