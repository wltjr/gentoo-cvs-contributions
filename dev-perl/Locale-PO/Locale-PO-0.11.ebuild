# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-PO/Locale-PO-0.11.ebuild,v 1.8 2004/05/26 10:01:50 kloeri Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Object-oriented interface to gettext po-file entries"
SRC_URI="http://www.cpan.org/authors/id/ALANSZ/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/ALANSZ/${P}.readme"

DEPEND="${DEPEND}
	sys-devel/gettext"
RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~ppc ~sparc alpha s390"
