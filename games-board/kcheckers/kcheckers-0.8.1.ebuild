# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/kcheckers/kcheckers-0.8.1.ebuild,v 1.4 2008/06/30 22:50:55 nyhm Exp $

EAPI=1
inherit eutils qt4 games

DESCRIPTION="Qt version of the classic boardgame checkers"
HOMEPAGE="http://kcheckers.wibix.de/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="|| ( x11-libs/qt-gui:4 x11-libs/qt:4 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:/usr/local:${GAMES_DATADIR}:" \
		common.h || die "sed common.h failed"

	sed -i \
		-e "s:PREFIX\"/share:\"${GAMES_DATADIR}:" \
		main.cc toplevel.cc || die "sed failed"
}

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dogamesbin kcheckers || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r i18n/* themes || die "doins failed"

	newicon icons/biglogo.png ${PN}.png
	make_desktop_entry ${PN} KCheckers

	dodoc AUTHORS ChangeLog FAQ README TODO
	prepgamesdirs
}
