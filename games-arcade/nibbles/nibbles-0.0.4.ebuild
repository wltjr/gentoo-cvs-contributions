# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/nibbles/nibbles-0.0.4.ebuild,v 1.11 2008/03/20 00:40:14 nyhm Exp $

inherit games

MY_P=${PN}-v${PV}
DESCRIPTION="An ncurses-based Nibbles clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/nibbles.html"
SRC_URI="http://www.earth.li/projectpurple/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/ncurses"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s#/usr/local/games/nibbles.levels#${GAMES_DATADIR}/${PN}#" \
		nibbles.h \
		|| die "sed failed"

	sed -i \
		-e "s#/var/lib/games/nibbles.score#${GAMES_STATEDIR}/nibbles.scores#" \
		scoring.h \
		|| die "sed failed"
	sed -i \
		-e '/c.o:/d' \
		-e '/CC.*-c/d' \
		-e '/^CC/d' Makefile \
		|| die "sed failed"
}

src_install() {
	dogamesbin nibbles || die "dogamesbin"

	insinto "${GAMES_DATADIR}/${PN}"
	doins nibbles.levels/* || die "doins failed"

	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/nibbles.scores"

	dodoc HISTORY CREDITS TODO README

	prepgamesdirs

	fperms 664 "${GAMES_STATEDIR}/nibbles.scores"
}
