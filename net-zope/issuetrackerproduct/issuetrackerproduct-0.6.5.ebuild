# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/issuetrackerproduct/issuetrackerproduct-0.6.5.ebuild,v 1.2 2006/01/27 02:36:23 vapier Exp $

inherit zproduct

DESCRIPTION="Friendly Issue tracking system for Zope"
HOMEPAGE="http://www.issuetrackerproduct.com"
SRC_URI="${HOMEPAGE}/Download/IssueTrackerProduct-${PV}.tgz"

LICENSE="ZPL"
KEYWORDS="~ppc ~x86"

RDEPEND=">=dev-python/stripogram-1.4"

ZPROD_LIST="IssueTrackerProduct"
