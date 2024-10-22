# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Archive-Rar/Archive-Rar-1.9.ebuild,v 1.21 2007/11/19 18:59:14 ian Exp $

inherit perl-module

DESCRIPTION="Archive::Rar - Interface with the rar command"
HOMEPAGE="http://www.cpan.org/modules/by-module/Archive/"
SRC_URI="mirror://cpan/authors/id/J/JM/JMBO/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="dev-lang/perl
	app-arch/rar"
