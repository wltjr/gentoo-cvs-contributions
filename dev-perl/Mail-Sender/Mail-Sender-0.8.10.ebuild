# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Sender/Mail-Sender-0.8.10.ebuild,v 1.8 2006/10/10 21:12:51 mcummings Exp $

inherit perl-module

DESCRIPTION="Module for sending mails with attachments through an SMTP server"
HOMEPAGE="http://search.cpan.org/~jenda/Mail-Sender-0.8.10"
SRC_URI="mirror://cpan/authors/id/J/JE/JENDA/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="ia64 x86"
IUSE=""

DEPEND="virtual/perl-MIME-Base64
	dev-lang/perl"

src_compile() {
	echo "n" | perl-module_src_compile
}
