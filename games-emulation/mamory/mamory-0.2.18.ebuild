# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mamory/mamory-0.2.18.ebuild,v 1.1 2005/03/17 06:27:36 mr_bones_ Exp $

inherit games

DESCRIPTION="rom management tools and library"
HOMEPAGE="http://mamory.sourceforge.net/"
SRC_URI="mirror://sourceforge/mamory/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	egamesconf \
		--disable-debug \
		--disable-dependency-tracking \
		--includedir=/usr/include || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
	dohtml DOCS/mamory.html
	prepgamesdirs
}
