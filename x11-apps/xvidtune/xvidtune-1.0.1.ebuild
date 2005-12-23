# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xvidtune/xvidtune-1.0.1.ebuild,v 1.1 2005/12/23 10:50:19 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xvidtune application"
KEYWORDS="~arm ~mips ~s390 ~sparc ~x86"
IUSE="xprint"
RDEPEND="x11-libs/libXxf86vm
	x11-libs/libXaw"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"

pkg_setup() {
	if use xprint && ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}
