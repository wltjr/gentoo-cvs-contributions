# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/chickens/chickens-0.2.4.ebuild,v 1.10 2007/02/25 13:01:28 nyhm Exp $

inherit games

MY_P="ChickensForLinux-Linux-${PV}"
DESCRIPTION="Target chickens with rockets and shotguns. Funny"
HOMEPAGE="http://moistrous.com/chickens/getchickens.php"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

DEPEND="media-libs/allegro"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:HighScores:${GAMES_STATEDIR}/${PN}/HighScores:" \
		-e "s:....\(.\)\(_\)\(.*.4x0\)\(.\):M\4\2\x42\x6Fn\1s\2:" \
		highscore.cpp HighScores \
		|| die "sed failed"
	sed -i \
		-e "s:options.cfg:${GAMES_SYSCONFDIR}/${PN}/options.cfg:" \
		-e "s:\"sound/:\"${GAMES_DATADIR}/${PN}/sound/:" \
		-e "s:\"dat/:\"${GAMES_DATADIR}/${PN}/dat/:" main.cpp README \
		|| die "sed failed"
	sed -i '/^CPPFLAGS/d' configure || die "sed failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r dat sound || die "doins failed"
	dodoc AUTHOR README
	insinto "${GAMES_STATEDIR}"/${PN}
	doins HighScores || die "doins failed"
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins options.cfg || die "doins failed"
	fperms g+w "${GAMES_STATEDIR}"/${PN}/HighScores
	prepgamesdirs
}
