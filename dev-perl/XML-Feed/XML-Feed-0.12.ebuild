# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Feed/XML-Feed-0.12.ebuild,v 1.1 2008/08/01 15:07:55 tove Exp $

MODULE_AUTHOR=BTROTT
inherit perl-module

DESCRIPTION="Syndication feed parser and auto-discovery"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl
	dev-perl/Class-ErrorHandler
	dev-perl/Feed-Find
	dev-perl/URI-Fetch
	dev-perl/XML-RSS
	>=dev-perl/XML-Atom-0.28
	dev-perl/DateTime
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/HTML-Parser
	dev-perl/libwww-perl"

SRC_TEST=do
PREFER_BUILDPL=no
