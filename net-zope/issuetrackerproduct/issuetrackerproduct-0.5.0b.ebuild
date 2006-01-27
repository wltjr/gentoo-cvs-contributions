# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/issuetrackerproduct/issuetrackerproduct-0.5.0b.ebuild,v 1.8 2006/01/27 02:36:23 vapier Exp $

inherit zproduct

DESCRIPTION="Issue tracking system"
HOMEPAGE="http://www.zope.org/Members/peterbe/IssueTrackerProduct"
SRC_URI="${HOMEPAGE}/IssueTrackerProduct-${PV}.tgz"

LICENSE="ZPL"
KEYWORDS="~ppc x86"

# Wondering if these should be turned into local USE flags.
RDEPEND=">=dev-python/stripogram-1.4"

ZPROD_LIST="IssueTrackerProduct"
