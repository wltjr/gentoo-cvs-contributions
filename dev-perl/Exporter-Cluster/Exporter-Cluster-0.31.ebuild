# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Exporter-Cluster/Exporter-Cluster-0.31.ebuild,v 1.10 2007/07/10 23:33:28 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Extension for easy multiple module imports"
HOMEPAGE="http://search.cpan.org/~dhageman/"
SRC_URI="mirror://cpan/authors/id/D/DH/DHAGEMAN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl"
