# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RPC-XML/RPC-XML-0.53.ebuild,v 1.12 2006/11/24 18:19:12 mcummings Exp $

inherit perl-module

DESCRIPTION="A  Perl extension interface to James Clark's XML parser, expat."
SRC_URI="mirror://cpan/authors/id/R/RJ/RJRAY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rjray/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE="modperl"

DEPEND="dev-perl/libwww-perl
	dev-perl/XML-Parser
	modperl? ( www-apache/mod_perl )
	dev-lang/perl"
