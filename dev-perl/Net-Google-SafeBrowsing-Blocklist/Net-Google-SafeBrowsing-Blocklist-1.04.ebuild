# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Google-SafeBrowsing-Blocklist/Net-Google-SafeBrowsing-Blocklist-1.04.ebuild,v 1.7 2008/07/05 09:38:41 robbat2 Exp $

MODULE_AUTHOR="DANBORN"
inherit perl-module

DESCRIPTION="Query a Google SafeBrowsing table"

IUSE="test"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"
RDEPEND="dev-perl/URI
		 >=virtual/perl-Math-BigInt-1.87
		 virtual/perl-DB_File
		 || (
			dev-perl/Math-BigInt-FastCalc
			dev-perl/Math-BigInt-GMP
			)"
DEPEND="${RDEPEND}
		test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
