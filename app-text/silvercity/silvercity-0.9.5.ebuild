# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/silvercity/silvercity-0.9.5.ebuild,v 1.2 2004/08/30 23:33:15 dholm Exp $

inherit distutils

DESCRIPTION="A lexical analyser for many langauges."
HOMEPAGE="http://silvercity.sourceforge.net/"

MY_P=${P/silvercity/SilverCity}
SRC_URI="mirror://sourceforge/silvercity/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

DEPEND=">=dev-lang/python-2.3"
