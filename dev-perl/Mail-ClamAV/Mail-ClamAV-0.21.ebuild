# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-ClamAV/Mail-ClamAV-0.21.ebuild,v 1.5 2008/03/10 15:16:48 beandog Exp $

inherit perl-module

DESCRIPTION="Perl extension for the clamav virus scanner."
HOMEPAGE="http://search.cpan.org/~sabeck/"
SRC_URI="mirror://cpan/authors/id/S/SA/SABECK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"

IUSE=""

DEPEND=">=app-antivirus/clamav-0.92
	dev-perl/Inline
	dev-lang/perl"

src_install() {
	perl-module_src_install
	dodoc README || die
}
