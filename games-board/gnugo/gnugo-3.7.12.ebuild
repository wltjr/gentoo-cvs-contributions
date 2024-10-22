# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnugo/gnugo-3.7.12.ebuild,v 1.1 2008/06/24 01:51:17 mr_bones_ Exp $

inherit games

DESCRIPTION="A Go-playing program"
HOMEPAGE="http://www.gnu.org/software/gnugo/devel.html"
SRC_URI="http://match.stanford.edu/gnugo/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="readline"

DEPEND=">=sys-libs/ncurses-5.2-r3
	readline? ( sys-libs/readline )"

src_compile() {
	egamesconf \
		$(use_with readline) \
		--disable-dependency-tracking \
		--enable-cache-size=32 || die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	prepgamesdirs
}
