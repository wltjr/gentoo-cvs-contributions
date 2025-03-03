# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mercury-extras/mercury-extras-0.12.2-r2.ebuild,v 1.16 2008/03/12 06:30:58 keri Exp $

inherit eutils

DESCRIPTION="Additional libraries and tools that are not part of the Mercury standard library"
HOMEPAGE="http://www.cs.mu.oz.au/research/mercury/index.html"
SRC_URI="ftp://ftp.mercury.cs.mu.oz.au/pub/mercury/old-releases/0.12.2/mercury-extras-0.12.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"

IUSE="doc glut iodbc opengl ncurses tcl tk xml"

DEPEND="~dev-lang/mercury-0.12.2
	glut? ( virtual/glut )
	iodbc? ( dev-db/libiodbc )
	ncurses? ( sys-libs/ncurses )
	opengl? ( virtual/opengl )
	tcl? ( tk? (
			dev-lang/tcl
			dev-lang/tk
			x11-libs/libX11
			x11-libs/libXmu ) )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-concurrency.patch
	epatch "${FILESDIR}"/${P}-curs.patch
	epatch "${FILESDIR}"/${P}-dynamic_linking.patch
	epatch "${FILESDIR}"/${P}-lex.patch
	epatch "${FILESDIR}"/${P}-mercury_glut.patch
	epatch "${FILESDIR}"/${P}-mercury_tcltk.patch
	epatch "${FILESDIR}"/${P}-mercury_opengl.patch
	epatch "${FILESDIR}"/${P}-odbc.patch
	epatch "${FILESDIR}"/${P}-posix.patch
	epatch "${FILESDIR}"/${P}-references.patch
	epatch "${FILESDIR}"/${P}-trailed_update.patch

	sed -i	-e "s:curs:concurrency curs:" \
		-e "s:posix:posix quickcheck:" Mmakefile

	if built_with_use dev-lang/mercury minimal; then
		sed -i -e "s:references::" Mmakefile
	else
		sed -i	-e "s:cgi:cgi clpr:" \
			-e "s:xml:trailed_update xml:" Mmakefile
	fi

	use iodbc && sed -i -e "s:moose:moose odbc:" Mmakefile
	use glut && sed -i -e "s: lex : graphics/mercury_glut lex :" Mmakefile
	use tcl && use tk && sed -i -e "s: lex : graphics/mercury_tcltk lex :" Mmakefile
	use opengl && sed -i -e "s: lex : graphics/mercury_opengl lex :" Mmakefile
	! use ncurses && sed -i -e "s:curs curses::" Mmakefile
	! use xml && sed -i -e "s:xml::" Mmakefile
}

src_compile() {
	mmake \
		-j1 depend || die "mmake depend failed"
	mmake \
		MMAKEFLAGS="${MAKEOPTS}" \
		EXTRA_MLFLAGS=--no-strip \
		|| die "mmake failed"

	if use opengl && use tcl && use tk ; then
		cd "${S}"/graphics/mercury_opengl
		cp ../mercury_tcltk/mtcltk.m ./
		mmake \
			-f Mmakefile.mtogl \
			-j1 depend || die "mmake depend mtogl failed"
		mmake \
			MMAKEFLAGS="${MAKEOPTS}" \
			-f Mmakefile.mtogl \
			|| die "mmake mtogl failed"
	fi
}

src_install() {
	mmake \
		MMAKEFLAGS="${MAKEOPTS}" \
		INSTALL_PREFIX="${D}"/usr \
		install || die "mmake install failed"

	if use opengl && use tcl && use tk ; then
		cd "${S}"/graphics/mercury_opengl
		mv Mmakefile Mmakefile.opengl
		mv Mmakefile.mtogl Mmakefile
		mmake \
			MMAKEFLAGS="${MAKEOPTS}" \
			INSTALL_PREFIX="${D}"/usr \
			install || die "mmake install mtogl failed"
	fi

	find "${D}"/usr/lib/mercury-${PV} -type l | xargs rm

	cd "${S}"
	if use doc ; then
		docinto samples/complex_numbers
		dodoc complex_numbers/samples/*.m

		if use ncurses ; then
			docinto samples/curs
			dodoc curs/samples/*.m

			docinto samples/curses
			dodoc curses/sample/*.m
		fi

		docinto samples/dynamic_linking
		dodoc dynamic_linking/hello.m

		docinto samples/lex
		dodoc lex/samples/*.m

		docinto samples/moose
		dodoc moose/samples/*.m moose/samples/*.moo

		docinto samples/references
		dodoc references/samples/*.m
	fi

	dodoc README
}
