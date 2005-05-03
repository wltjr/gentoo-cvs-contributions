# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/alienwave/alienwave-0.3.0.ebuild,v 1.4 2005/05/03 08:34:42 dholm Exp $

inherit games

DESCRIPTION="An ncurses-based Xenon clone"
HOMEPAGE="http://www.cs.unibo.it/~pira/alienwave/aw.html"
SRC_URI="http://www.cs.unibo.it/~pira/alienwave/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"
IUSE=""

DEPEND="sys-libs/ncurses"

S="${WORKDIR}/${PN}"

src_install() {
	dogamesbin alienwave || die "dogamesbin failed"
	dodoc TO_DO README STORY
	prepgamesdirs
}

