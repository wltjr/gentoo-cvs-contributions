# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xphelloworld/xphelloworld-0.99.0.ebuild,v 1.4 2005/10/19 03:00:45 geoman Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xphelloworld application"
KEYWORDS="~arm ~mips ~s390 ~sparc ~x86"
RDEPEND="x11-libs/libXaw
	x11-libs/libXprintUtil
	x11-libs/libXprintAppUtil
	x11-libs/libXt"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}
