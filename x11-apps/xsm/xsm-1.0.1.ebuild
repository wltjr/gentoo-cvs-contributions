# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xsm/xsm-1.0.1.ebuild,v 1.3 2006/07/30 09:15:13 stefaan Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xsm application"
KEYWORDS="~alpha ~arm ~mips ~ppc64 ~s390 ~sparc ~x86"
IUSE="xprint"
RDEPEND="x11-libs/libXaw
	net-misc/netkit-rsh"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"

pkg_setup() {
	if use xprint && ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}
