# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefonts/freefonts-0.10-r3.ebuild,v 1.2 2006/04/01 19:53:26 agriffis Exp $

inherit font

DESCRIPTION="A Collection of Free Type1 Fonts"
SRC_URI="mirror://gimp/fonts/${P}.tar.gz"
HOMEPAGE="http://www.gimp.org"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="freedist"
IUSE="X"

FONT_S=${WORKDIR}/freefont
S=${FONT_S}

FONT_SUFFIX="pfb"
DOCS="README *.license"
