# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/pmars-sdl/pmars-sdl-0.9.2e.ebuild,v 1.10 2006/10/09 11:10:11 nyhm Exp $

inherit toolchain-funcs games

MY_PN="${PN/-sdl/}"
MY_PV="${PV/e/-5}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Portable redcode simulator's sdl port for core war"
HOMEPAGE="http://www.cs.helsinki.fi/u/jpihlaja/cw/pmars-sdl"
SRC_URI="http://www.cs.helsinki.fi/u/jpihlaja/cw/pmars-sdl/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="sdl X svga"

DEPEND="sdl? ( x11-libs/libX11 media-libs/libsdl )
	X? ( x11-libs/libX11 )
	svga? ( media-libs/svgalib )"

S=${WORKDIR}/${MY_P}

src_compile() {
	CFLAGS="${CFLAGS} -DEXT94 -DPERMUTATE"
	LFLAGS="-x"

	if use sdl ; then
		CFLAGS="${CFLAGS} -DSDLGRAPHX `sdl-config --cflags`"
		LIB=`sdl-config --libs`
	elif use X ; then
		CFLAGS="${CFLAGS} -DXWINGRAPHX"
		LIB="-L/usr/X11R6/lib -lX11"
	elif use svga ; then
		CFLAGS="${CFLAGS} -DGRAPHX"
		LIB="-lvgagl -lvga"
	else
		CFLAGS="${CFLAGS} -DCURSESGRAPHX"
		LIB="-lcurses -ltermcap"
	fi

	cd src

	SRC="asm.c
		 cdb.c
		 clparse.c
		 disasm.c
		 eval.c
		 global.c
		 pmars.c
		 sim.c
		 pos.c
		 str_eng.c
		 token.c"

	for x in ${SRC}; do
		einfo "compiling ${x}"
		$(tc-getCC) ${CFLAGS} ${x} -c || die
	done

	echo
	einfo "linking with LIB: ${LIB}"
	$(tc-getCC) *.o ${LIB} -o ${MY_PN} || die
}

src_install() {
	dogamesbin src/${MY_PN} || die
	doman doc/${MY_PN}.6

	dodoc AUTHORS CONTRIB ChangeLog README doc/redcode.ref

	insinto "${GAMES_DATADIR}/${MY_PN}/warriors"
	doins warriors/*

	insinto "${GAMES_DATADIR}/${MY_PN}/macros"
	doins config/*.mac

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "There are some macros in ${GAMES_DATADIR}/${MY_PN}/macros"
	ewarn "which you should make accessible to pmars by typing"
	ewarn "export PMARSHOME=${GAMES_DATADIR}/${MY_PN}/macros\n"
}
