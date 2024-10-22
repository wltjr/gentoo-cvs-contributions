# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcompmgr/xcompmgr-1.1.3-r1.ebuild,v 1.5 2007/09/29 10:24:25 armin76 Exp $

inherit x-modular

DESCRIPTION="X Compositing manager"
HOMEPAGE="http://freedesktop.org/Software/xapps"
SRC_URI="http://xapps.freedesktop.org/release/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE=""
RDEPEND="x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXcomposite"

PATCHES="${FILESDIR}/fix-unmapped-window-opacity.patch"
