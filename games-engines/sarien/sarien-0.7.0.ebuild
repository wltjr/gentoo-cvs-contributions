# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/sarien/sarien-0.7.0.ebuild,v 1.6 2004/09/11 09:04:29 blubb Exp $

inherit games

DESCRIPTION="Sierra AGI resource interpreter engine"
HOMEPAGE="http://sarien.sourceforge.net/"
SRC_URI="mirror://sourceforge/sarien/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

RDEPEND="virtual/libc
	virtual/x11"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:/etc:${GAMES_SYSCONFDIR}:" src/filesys/unix/path.c \
			|| die "sed src/filesys/unix/path.c failed"
}

src_compile() {
	egamesconf || die
	# buggy build - comments on bug #45813
	emake -j1 || die "emake failed"
}

src_install() {
	dogamesbin bin/sarien || die "dogamesbin failed"
	insinto "${GAMES_SYSCONFDIR}"
	doins etc/sarien.cfg || die "doins failed"
	dodoc doc/{AUTHORS,BUGS,Changelog,README*,TODO,roadmap.txt}
	prepgamesdirs
}
