# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/sturmbahnfahrer/sturmbahnfahrer-1.3.ebuild,v 1.1 2007/02/23 05:19:02 mr_bones_ Exp $

inherit toolchain-funcs games

DESCRIPTION="Simulated obstacle course for automobiles"
HOMEPAGE="http://www.sturmbahnfahrer.com/"
SRC_URI="http://www.stolk.org/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	virtual/glut
	>=dev-games/ode-0.6
	>=media-libs/plib-1.8.4
	media-libs/alsa-lib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:/usr/share/games/${PN}:${GAMES_DATADIR}/${PN}:" main.cxx \
		|| die "sed failed"

	sed -i \
		-e "s:/usr/games:${GAMES_BINDIR}:" \
		-e 's:$(ODEPREFIX)/lib/libode.a:-lode:' \
		Makefile || die "sed failed"
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		GAMEDIR="${D}/${GAMES_DATADIR}/${PN}" \
		|| die "emake install failed"

	dodoc JOYSTICKS README TODO
	prepgamesdirs
}
