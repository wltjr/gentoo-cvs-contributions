# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hangman/hangman-0.9.2.ebuild,v 1.3 2004/05/12 09:02:45 mr_bones_ Exp $

inherit games

DESCRIPTION="The classic word guessing game"
HOMEPAGE="http://www.shiftygames.com/hangman/hangman.html"
SRC_URI="http://www.shiftygames.com/hangman/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}
	sys-apps/miscfiles"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	prepgamesdirs
}
