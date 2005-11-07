# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/twm/twm-0.99.0.ebuild,v 1.2 2005/11/07 05:20:33 cardoe Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org twm application"
KEYWORDS="~arm ~mips ~ppc ~s390 ~sparc ~x86"
RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu"
DEPEND="${RDEPEND}"
