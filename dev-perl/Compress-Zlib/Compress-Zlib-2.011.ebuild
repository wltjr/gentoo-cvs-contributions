# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Zlib/Compress-Zlib-2.011.ebuild,v 1.2 2008/07/15 17:02:59 armin76 Exp $

MODULE_AUTHOR=PMQS

inherit perl-module

DESCRIPTION="A Zlib perl module"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/zlib
	>=dev-perl/Compress-Raw-Zlib-${PV}
	>=dev-perl/IO-Compress-Base-${PV}
	>=dev-perl/IO-Compress-Zlib-${PV}
	virtual/perl-Scalar-List-Utils
	dev-lang/perl"

SRC_TEST="do"

mydoc="TODO"
