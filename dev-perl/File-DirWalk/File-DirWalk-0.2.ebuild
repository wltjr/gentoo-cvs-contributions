# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-DirWalk/File-DirWalk-0.2.ebuild,v 1.10 2007/07/10 23:33:26 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="File::DirWalk - walk through a directory tree and run own code."
HOMEPAGE="http://search.cpan.org/~jensl/${P}/"
SRC_URI="mirror://cpan/authors/id/J/JE/JENSL/${P}.tar.gz"
SRC_TEST="do"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
