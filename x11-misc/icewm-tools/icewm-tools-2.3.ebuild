# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/icewm-tools/icewm-tools-2.3.ebuild,v 1.1 2003/07/01 12:01:43 phosphan Exp $

DESCRIPTION="Convenience package for IceWM control center and tools"
SRC_URI=""
HOMEPAGE="http://icecc.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=x11-misc/icebgset-0.9
		>=x11-misc/icecc-2.3
		>=x11-misc/icecursorscfg-0.6
		>=x11-misc/iceiconcvt-1.0
        >=x11-misc/iceked-1.2
		>=x11-misc/icemc-1.4
		>=x11-misc/icesndcfg-1.0
		>=x11-misc/icets-1.0
		>=x11-misc/icerrun-0.5
		>=x11-misc/icemergeprefs-0.5
		>=x11-misc/icewoed-1.4"

SLOT="0"

src_compile () {
	einfo "Nothing to do"
}

src_install () {
	einfo "Nothing to do"
}
