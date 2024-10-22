# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmoon/gkrellmoon-0.6-r1.ebuild,v 1.1 2008/04/11 12:43:37 lack Exp $

inherit gkrellm-plugin

IUSE=""
DESCRIPTION="A GKrellM2 plugin of the famous wmMoonClock dockapp"
SRC_URI="mirror://sourceforge/gkrellmoon/${P}.tar.gz"
HOMEPAGE="http://gkrellmoon.sourceforge.net/"

DEPEND="media-libs/imlib2"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^#include <stdio.h>/a#include <string.h>' CalcEphem.h
}
