# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/qgo/qgo-1.5.4.ebuild,v 1.5 2008/07/27 20:51:02 carlo Exp $

EAPI=1

inherit eutils autotools qt3 games

DESCRIPTION="A Qt Go client and SGF editor"
HOMEPAGE="http://qgo.sourceforge.net/"
SRC_URI="mirror://sourceforge/qgo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="x11-libs/qt:3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${P}-parallel.patch \
		"${FILESDIR}"/${P}-gcc43.patch
	sed -i 's:$(datadir):/usr/share:' \
		templates/Makefile.in \
		|| die "sed Makefile.in failed"
	sed -i "s:/usr/share:${GAMES_DATADIR}:" \
		templates/*.desktop \
		|| die "sed .desktop failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	prepgamesdirs
}
