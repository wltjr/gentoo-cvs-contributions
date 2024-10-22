# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/billardgl/billardgl-1.75-r1.ebuild,v 1.10 2007/02/14 01:40:34 nyhm Exp $

inherit eutils games

DESCRIPTION="an OpenGL billards game"
HOMEPAGE="http://www.billardgl.de/"
SRC_URI="mirror://sourceforge/${PN}/BillardGL-${PV}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libXi
	x11-libs/libXmu
	virtual/opengl
	virtual/glu
	virtual/glut"

S=${WORKDIR}/BillardGL-${PV}/src

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:/usr/share/BillardGL/:${GAMES_DATADIR}/${PN}/:" \
		Namen.h \
		|| die "sed Namen.h failed"
	sed -i \
		-e '/^CXXFLAGS/s:=.*\(-D.*\)-.*:+=\1:' \
		-e "/^LFLAGS/s:=:=${LDFLAGS}:" \
		Makefile \
		|| die "sed Makefile failed"
	sed -i \
		-e 's:<iostream.h>:<iostream>:' \
		-e 's:<fstream.h>:<fstream>\nusing namespace std;:' \
		bmp.cpp \
		|| die "sed bmp.cpp failed"
}

src_install() {
	newgamesbin BillardGL ${PN} || die "newgamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r lang Texturen || die "doins failed"
	dodoc README
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} BillardGL
	prepgamesdirs
}
